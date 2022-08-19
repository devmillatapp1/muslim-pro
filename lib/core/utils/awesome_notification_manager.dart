import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:muslim/app/data/app_data.dart';
import 'package:muslim/app/modules/quran/quran_controller.dart';
import 'package:muslim/app/shared/functions/print.dart';
import 'package:muslim/app/shared/transition_animation/transition_animation.dart';
import 'package:muslim/app/modules/azkar_card.dart/azkar_read_card.dart';
import 'package:muslim/app/modules/azkar_page/azkar_read_page.dart';
import 'package:muslim/app/modules/quran/quran_read_page.dart';

AwesomeNotificationManager awesomeNotificationManager =
    AwesomeNotificationManager();

class AwesomeNotificationManager {
  Future<void> checkIfAllowed(BuildContext context) async {
    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: const Text('هل تريد السماح بتشغيل الإشعارات؟'),
              content: const Text(
                  'التطبيق يحتاج إلى أخذ الإذن لتشغيل الإشعارات لتعمل معك التنبيهات بشكل سليم'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'ذكرني لاحقًا',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: const Text(
                    'السماح',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<void> init() async {
    await AwesomeNotifications().initialize(
      /// using null here mean it will use app icon for notification icon
      /// If u want use custom one replace null with below
      /// 'resource://drawable/res_app_icon',
      null,
      [
        NotificationChannel(
          channelKey: 'in_app_notification',
          channelName: 'In App Notification',
          channelDescription: '',
          defaultColor: Colors.teal,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          enableLights: true,
          playSound: true,
        ),
        NotificationChannel(
          channelKey: 'scheduled_channel',
          channelName: 'Scheduled Notifications',
          channelDescription: '',
          defaultColor: Colors.teal,
          importance: NotificationImportance.High,
          locked: true,
          channelShowBadge: true,
          playSound: true,
        ),
      ],
      debug: true,
    );
  }

  void listen() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      /// Check if awesome notification is allowed
      await awesomeNotificationManager.checkIfAllowed(Get.context!);

      ///
      AwesomeNotifications()
          .createdStream
          .listen((ReceivedNotification receivedNotification) async {
        List<String> payloadsList =
            receivedNotification.payload!.values.toList();
        String payload = payloadsList[0];
        hisnPrint("createdStream: $payload");
      });

      ///
      AwesomeNotifications()
          .actionStream
          .listen((ReceivedNotification receivedNotification) async {
        List<String> payloadsList =
            receivedNotification.payload!.values.toList();
        String payload = payloadsList[0];
        hisnPrint("actionStream: $payload");
        bool channelCheck =
            receivedNotification.channelKey == 'in_app_notification' ||
                receivedNotification.channelKey == 'scheduled_channel';
        if (channelCheck && Platform.isIOS) {
          await AwesomeNotifications().getGlobalBadgeCounter().then(
            (value) async {
              await AwesomeNotifications().setGlobalBadgeCounter(value - 1);
            },
          );
        }

        if (payload.isNotEmpty) {
          onNotificationClick(payload);
        } else {
          hisnPrint("actionStream: Else");
        }
      });
    });
  }

  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }

  Future<void> cancelNotificationById({
    required int id,
  }) async {
    await AwesomeNotifications().cancelSchedule(id);
  }

  /// Show Notification
  Future<void> showCustomNotification({
    required String title,
    String? body,
    required String payload,
  }) async {
    // int id = createUniqueId();c
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 999,
        channelKey: 'in_app_notification',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.BigText,
        payload: {'Open': payload},
        fullScreenIntent: true,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'Dismiss',
          label: 'تفويت',
          buttonType: ActionButtonType.DisabledAction,
        ),
        NotificationActionButton(
          key: 'Start',
          label: 'الشروع في الذكر',
        ),
      ],
    );
  }

  /// Show Notification
  Future<void> appOpenNotification() async {
    var scheduleNotificationDateTime =
        DateTime.now().add(const Duration(days: 3));
    // int id = createUniqueId();c
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1000,
        channelKey: 'scheduled_channel',
        title: 'لم تفتح التطبيق منذ فنرة 😀',
        body: 'فَاذْكُرُونِي أَذْكُرْكُمْ وَاشْكُرُوا لِي وَلَا تَكْفُرُونِ',
        notificationLayout: NotificationLayout.BigText,
        payload: {'Open': "2"},
      ),
      schedule: NotificationCalendar.fromDate(
        date: scheduleNotificationDateTime,
        allowWhileIdle: true,
        repeats: true,
        preciseAlarm: true,
      ),
    );
  }

  /// Add weekly notification
  Future<void> addCustomWeeklyReminder({
    required int id,
    required String title,
    String? body,
    required String payload,
    required Time time,
    required Day day,
    bool needToOpen = true,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'scheduled_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.BigText,
        payload: {'Open': payload},
      ),
      schedule: NotificationCalendar(
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        preciseAlarm: true,
        allowWhileIdle: true,
        repeats: true,
        weekday: day.value,
        hour: time.hour,
        minute: time.minute,
        second: 0,
        millisecond: 0,
      ),
      actionButtons: needToOpen
          ? [
              NotificationActionButton(
                key: 'Dismiss',
                label: 'تفويت',
                buttonType: ActionButtonType.DisabledAction,
              ),
              NotificationActionButton(
                key: 'Start',
                label: 'الشروع في الذكر',
              ),
            ]
          : [
              NotificationActionButton(
                key: 'Dismiss',
                label: 'تفويت',
                buttonType: ActionButtonType.DisabledAction,
              ),
            ],
    );
  }

  /// Add Daily notification
  Future<void> addCustomDailyReminder({
    required int id,
    required String title,
    String? body,
    required Time time,
    required String payload,
    bool needToOpen = true,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'scheduled_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.BigText,
        payload: {'Open': payload},
      ),
      schedule: NotificationCalendar(
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        preciseAlarm: true,
        allowWhileIdle: true,
        hour: time.hour,
        minute: time.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ),
      actionButtons: needToOpen
          ? [
              NotificationActionButton(
                key: 'Dismiss',
                label: 'تفويت',
                buttonType: ActionButtonType.DisabledAction,
              ),
              NotificationActionButton(
                key: 'Start',
                label: 'الشروع في الذكر',
              ),
            ]
          : [
              NotificationActionButton(
                key: 'Dismiss',
                label: 'تفويت',
                buttonType: ActionButtonType.DisabledAction,
              ),
            ],
    );
  }

  ///
  onNotificationClick(String payload) {
    /// go to quran page if clicked
    if (payload == "الكهف") {
      transitionAnimation.fromBottom2Top(
          context: Get.context!,
          goToPage: const QuranReadPage(
            surahName: SurahNameEnum.alKahf,
          ));
    }

    /// ignore constant alarms if clicked
    else if (payload == "555" || payload == "666") {
    }

    /// go to zikr page if clicked
    else {
      int? pageIndex = int.parse(payload);
      //
      if (appData.isCardReadMode) {
        transitionAnimation.fromBottom2Top(
            context: Get.context!, goToPage: AzkarReadCard(index: pageIndex));
      } else {
        transitionAnimation.fromBottom2Top(
            context: Get.context!, goToPage: AzkarReadPage(index: pageIndex));
      }
    }
  }

  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
  }
}
