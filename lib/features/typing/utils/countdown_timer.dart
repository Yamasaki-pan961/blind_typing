import 'dart:async';
import 'dart:ui';

class CountdownTimer {
  final Duration _timeLimit;

  final Duration _tick;

  final VoidCallback _onEndedCallback;

  final Function(CountdownTimer timer) _onTickedCallback;

  Timer? _timer;

  Duration _elapsed = const Duration(seconds: 0);

  CountdownTimer(
    this._timeLimit,
    this._tick,
    this._onEndedCallback,
    this._onTickedCallback,
  );

  Duration get elapsedTime => _elapsed;
  Duration get remainingTimer => _timeLimit - _elapsed;

  void start() {
    _timer ??= Timer.periodic(_tick, _onTicked);
  }

  void stop() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  void _onTicked(Timer t) {
    _elapsed += _tick;
    _onTickedCallback(this);

    if (_elapsed >= _timeLimit) {
      _onEndedCallback();
      t.cancel();
    }
  }
}
