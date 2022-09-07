import 'package:blind_typing/features/typing/utils/countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CountdownTimerWidget extends HookWidget {
  const CountdownTimerWidget(
      {required this.timeLimit,
      required this.tick,
      required this.onEndedCallback,
      required this.isCountdown,
      super.key});

  final Duration timeLimit;
  final Duration tick;
  final VoidCallback onEndedCallback;
  final bool isCountdown;

  @override
  Widget build(BuildContext context) {
    final remainderTimeState = useState(timeLimit);
    final timer = useMemoized(() => CountdownTimer(
          timeLimit,
          tick,
          onEndedCallback,
          (timer) {
            remainderTimeState.value = timer.remainingTimer;
          },
        ));
    if (isCountdown) {
      timer.start();
    } else {
      remainderTimeState.value = timeLimit;
      timer.reset();
    }
    return Text(
      () {
        final durationData = remainderTimeState.value.durationData;
        return '${durationData.seconds}.${durationData.microseconds ~/ 10000}';
      }(),
      style: Theme.of(context).textTheme.displayMedium,
    );
  }
}

extension DurationExtension on Duration {
  DurationData get durationData {
    var microseconds = inMicroseconds;

    final hours = microseconds ~/ Duration.microsecondsPerHour;
    microseconds = microseconds.remainder(Duration.microsecondsPerHour);

    if (microseconds < 0) microseconds = -microseconds;

    final minutes = microseconds ~/ Duration.microsecondsPerMinute;
    microseconds = microseconds.remainder(Duration.microsecondsPerMinute);

    final seconds = microseconds ~/ Duration.microsecondsPerSecond;
    microseconds = microseconds.remainder(Duration.microsecondsPerSecond);

    return DurationData(hours, minutes, seconds, microseconds);
  }
}

class DurationData {
  final int hours;
  final int minutes;
  final int seconds;
  final int microseconds;

  DurationData(this.hours, this.minutes, this.seconds, this.microseconds);
  @override
  String toString() {
    return '$hours:$minutes:$seconds.$microseconds';
  }
}
