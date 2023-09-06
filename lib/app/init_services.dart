import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:muslim/app/shared/functions/print.dart';
import 'package:muslim/core/utils/alarm_manager.dart';
import 'package:muslim/core/utils/awesome_notification_manager.dart';
import 'package:muslim/core/utils/migration/migration.dart';
import 'package:muslim/core/utils/notification_manager.dart';

Future<void> initServices() async {
  try {
    await GetStorage.init();
    await Migration.start();
    await awesomeNotificationManager.init();
    await alarmManager.checkAllAlarmsInDb();
    await localNotifyManager.cancelAllNotifications();
    await awesomeNotificationManager.appOpenNotification();
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  } catch (e) {
    hisnPrint(e);
  }
}
