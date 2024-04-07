import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/notifications/data/notification_channel.dart';
import 'package:clock_app/stopwatch/types/stopwatch.dart';
import 'package:clock_app/timer/types/time_duration.dart';

Future<void> updateStopwatchNotification(ClockStopwatch stopwatch) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: stopwatch.id,
        channelKey: stopwatchNotificationChannelKey,
        title: 'Stopwatch',
        body:
            "${TimeDuration.fromMilliseconds(stopwatch.elapsedMilliseconds).toTimeString(showMilliseconds: false)} - LAP ${stopwatch.laps.length + 1}",
        category: NotificationCategory.StopWatch,
      ),
      actionButtons: [
        NotificationActionButton(
          showInCompactView: true,
          key: "stopwatch_toggle_state",
          label: stopwatch.isRunning ? 'Pause' : 'Start',
          actionType: ActionType.SilentAction,
          autoDismissible: false,
        ),
        NotificationActionButton(
          showInCompactView: true,
          key: "stopwatch_reset",
          label: 'Reset',
          actionType: ActionType.SilentAction,
          autoDismissible: false,
        ),
        NotificationActionButton(
          showInCompactView: true,
          key: "stopwatch_lap",
          label: 'Lap',
          actionType: ActionType.SilentAction,
          autoDismissible: false,
        )
      ]);
}
