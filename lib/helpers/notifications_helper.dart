import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsHelper {
  static final _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final _initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  static final _initializationSettings =
      InitializationSettings(android: _initializationSettingsAndroid);

  static final _androidNotificationDetails = AndroidNotificationDetails(
    'channel id',
    'channel name',
    'channel description',
    priority: Priority.high,
    importance: Importance.max,
  );

  static final _notificationDetails =
      NotificationDetails(android: _androidNotificationDetails);

  static Future<void> init() async {
    await _flutterLocalNotificationsPlugin.initialize(
      _initializationSettings,
      onSelectNotification: _onClickNotification,
    );
    tz.initializeDatabase([]);
  }

  static Future<void> setScheduleNotification(int offsetMinutes) async {
    await _cancelAllNotifications();
    if (offsetMinutes <= 0) return;

    // calc next notification time
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, now.hour, now.minute);
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local)))
      scheduledDate = scheduledDate.add(Duration(minutes: offsetMinutes));

    // setup notification
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'You need to drink another cup of water!',
        'Don\'t forget to improve your progress in the app',
        scheduledDate,
        _notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  // ToDo periodic notification if user miss schedule notification
  //static Future<void> setPeriodicNotification(int offset_minutes) {}

  // ToDo configure timezones (ios version)
  // static Future<void> _configureLocalTimeZone() async {
  //   tz.initializeTimeZones();
  //   final String timeZoneName = await platform.invokeMethod('getTimeZoneName');
  //   tz.setLocalLocation(tz.getLocation(timeZoneName));
  // }

  static Future<void> _onClickNotification(String payload) async {
    // cancel notifications if user enter the app
    await _cancelAllNotifications();
  }

  static Future<void> _cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> _cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
