// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:get_storage/get_storage.dart';
import 'package:muslim/generated/l10n.dart';
import 'package:muslim/src/core/di/dependency_injection.dart';
import 'package:muslim/src/core/functions/print.dart';
import 'package:muslim/src/core/functions/show_toast.dart';
import 'package:muslim/src/core/values/constant.dart';
import 'package:muslim/src/features/alarms_manager/data/models/alarm.dart';
import 'package:muslim/src/features/alarms_manager/data/models/alarm_repeat_type.dart';
import 'package:muslim/src/features/alarms_manager/data/models/awesome_notification_manager.dart';
import 'package:muslim/src/features/alarms_manager/data/repository/alarm_database_helper.dart';

class AlarmManager {
  final AwesomeNotificationManager awesomeNotificationManager;

  AlarmManager(this.awesomeNotificationManager);

  Future<void> alarmState({
    required DbAlarm dbAlarm,
    bool showMsg = true,
  }) async {
    if (dbAlarm.isActive) {
      if (showMsg) {
        showToast(msg: "${S.current.activate}: ${dbAlarm.title}");
      }

      if (dbAlarm.repeatType == AlarmRepeatType.daily) {
        await awesomeNotificationManager.addCustomDailyReminder(
          id: dbAlarm.titleId,
          title: dbAlarm.title,
          body: dbAlarm.body,
          time: Time(dbAlarm.hour, dbAlarm.minute),
          payload: dbAlarm.titleId.toString(),
        );
      } else {
        await awesomeNotificationManager.addCustomWeeklyReminder(
          id: dbAlarm.titleId,
          title: dbAlarm.title,
          body: dbAlarm.body,
          time: Time(dbAlarm.hour, dbAlarm.minute),
          payload: dbAlarm.titleId.toString(),
          weekday: dbAlarm.repeatType.getWeekDay(),
        );
      }
    } else {
      if (showMsg) {
        showToast(msg: "${S.current.deactivate}: ${dbAlarm.title}");
      }

      await awesomeNotificationManager.cancelNotificationById(
        id: dbAlarm.titleId,
      );
    }
  }

  Future<void> checkAllAlarmsInDb() async {
    final box = GetStorage(kAppStorageKey);

    ///todo what [is_awesome_set] mean ?
    final bool isAwesomeSet = box.read<bool>('is_awesome_set') ?? false;
    if (!isAwesomeSet) {
      hisnPrint("Setup Awesome from database ....");
      final alarms = await sl<AlarmDatabaseHelper>().getAlarms();
      for (var i = 0; i < alarms.length; i++) {
        final DbAlarm alarm = alarms[i];
        await alarmState(dbAlarm: alarm, showMsg: false);
      }
      box.write('is_awesome_set', true);
    }
  }
}
