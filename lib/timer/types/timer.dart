import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:clock_app/alarm/logic/schedule_alarm.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/types/timer_state.dart';
import 'package:clock_app/common/utils/duration.dart';
import 'package:clock_app/timer/types/time_duration.dart';

class ClockTimer extends ListItem {
  final TimeDuration _duration;
  int _secondsRemainingOnPause;
  DateTime _startTime;
  TimerState _state;
  final int _id;
  bool vibrate = true;

  @override
  int get id => _id;
  TimeDuration get duration => _duration;
  int get remainingSeconds {
    if (isRunning) {
      return math.max(
          _secondsRemainingOnPause -
              DateTime.now().difference(_startTime).toTimeDuration().inSeconds,
          0);
    } else {
      return _secondsRemainingOnPause;
    }
  }

  bool get isRunning => _state == TimerState.running;
  TimerState get state => _state;

  ClockTimer(this._duration)
      : _id = UniqueKey().hashCode,
        _secondsRemainingOnPause = _duration.inSeconds,
        _startTime = DateTime(0),
        _state = TimerState.stopped;

  ClockTimer.fromTimer(ClockTimer timer)
      : _duration = timer._duration,
        _secondsRemainingOnPause = timer._duration.inSeconds,
        _startTime = DateTime(0),
        _state = TimerState.stopped,
        _id = UniqueKey().hashCode;

  void start() {
    _startTime = DateTime.now();
    scheduleAlarm(
        _id, DateTime.now().add(Duration(seconds: _secondsRemainingOnPause)),
        type: ScheduledNotificationType.timer);
    _state = TimerState.running;
  }

  void pause() {
    cancelAlarm(_id);
    _secondsRemainingOnPause = _secondsRemainingOnPause -
        DateTime.now().difference(_startTime).toTimeDuration().inSeconds;
    _state = TimerState.paused;
  }

  void reset() {
    cancelAlarm(_id);
    _state = TimerState.stopped;
    _secondsRemainingOnPause = _duration.inSeconds;
  }

  void toggleState() {
    if (state == TimerState.running) {
      pause();
    } else {
      start();
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'duration': _duration.inSeconds,
      'id': _id,
      'durationRemainingOnPause': _secondsRemainingOnPause,
      'startTime': _startTime.toIso8601String(),
      'state': _state.toString(),
    };
  }

  ClockTimer.fromJson(Map<String, dynamic> json)
      : _duration = TimeDuration.fromSeconds(json['duration']),
        _secondsRemainingOnPause = json['durationRemainingOnPause'],
        _startTime = DateTime.parse(json['startTime']),
        _state =
            TimerState.values.firstWhere((e) => e.toString() == json['state']),
        _id = json['id'];
}
