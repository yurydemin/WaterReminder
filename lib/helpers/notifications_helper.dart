import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationsHelper {
  static Future<void> init() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/app_icon',
      [
        NotificationChannel(
          channelKey: 'schedule',
          channelName: 'Schedule notifications',
          channelDescription: 'Notification channel for drink schedules',
          defaultColor: Colors.blue,
          ledColor: Colors.white,
        ),
      ],
    );
  }

  static Future<void> setScheduleNotification(int offsetMinutes) async {
    await cancelAllScheduleNotifications();
    if (offsetMinutes <= 0) return;

    var scheduleDate = DateTime.now().add(Duration(minutes: offsetMinutes));
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 0,
          channelKey: 'schedule',
          title: 'Be healthy!',
          body: 'You need to drink another cup of water',
          payload: {'uuid': 'user-profile-uuid'}),
      actionButtons: [
        NotificationActionButton(
          key: 'DRINK',
          label: 'One drink',
          autoCancel: true,
          buttonType: ActionButtonType.KeepOnTop,
        ),
        NotificationActionButton(
          key: 'RESCHEDULE',
          label: 'Reschedule',
          autoCancel: true,
          buttonType: ActionButtonType.KeepOnTop,
          enabled: false,
        ),
      ],
      schedule: NotificationSchedule(
          crontabSchedule: CronHelper.instance
              .atDate(scheduleDate.toUtc(), initialSecond: 0)),
    );
  }

  static Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  static Future<void> cancelAllScheduleNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }
}
