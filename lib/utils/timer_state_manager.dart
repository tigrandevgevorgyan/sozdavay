
import 'dart:async';

class TimerStateManager {
  static final Map<String, TimerState> _timers = {};
  static final Map<String, Function()> _completionCallbacks = {};
  static Timer? _globalTimer;

  static void saveTimerState(String key, TimerState state) {
    _timers[key] = state;
    _startGlobalTimer();
  }

  static TimerState? getTimerState(String key) {
    final state = _timers[key];
    if (state != null && state.isCompletedByTime) {
      _completionCallbacks[key]?.call();
      removeTimer(key);
      return null;
    }
    return state;
  }

  static void setCompletionCallback(String key, Function() callback) {
    _completionCallbacks[key] = callback;
  }

  static void removeTimer(String key) {
    _timers.remove(key);
    _completionCallbacks.remove(key);
    if (_timers.isEmpty) {
      _globalTimer?.cancel();
      _globalTimer = null;
    }
  }

  static void clearAll() {
    _timers.clear();
  }

  static void stopAllExcept(String keyToKeep) {
    final keysToRemove = _timers.keys.where((k) => k != keyToKeep).toList();
    for (final key in keysToRemove) {
      _timers.remove(key);
    }
  }

  static void _startGlobalTimer() {
    if (_globalTimer != null) return;

    _globalTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      final completedKeys = <String>[];

      for (final entry in _timers.entries) {
        if (entry.value.isCompletedByTime) {
          completedKeys.add(entry.key);
        }
      }

      for (final key in completedKeys) {
        _completionCallbacks[key]?.call();
        removeTimer(key);
      }

      if (_timers.isEmpty) {
        timer.cancel();
        _globalTimer = null;
      }
    });
  }

}

class TimerState {
  final DateTime startTime;
  final int totalSeconds;
  final bool isRunning;

  TimerState({
    required this.startTime,
    required this.totalSeconds,
    required this.isRunning,
  });

  double get progress {
    if (!isRunning) return 0.0;

    final elapsed = DateTime.now().difference(startTime).inMilliseconds;
    final totalMs = totalSeconds * 1000;
    final progress = elapsed / totalMs;

    return progress.clamp(0.0, 1.0);
  }

  bool get isCompletedByTime => progress >= 1.0;

  int get remainingSeconds {
    if (!isRunning) return totalSeconds;

    final elapsed = DateTime.now().difference(startTime).inSeconds;
    final remaining = totalSeconds - elapsed;

    return remaining.clamp(0, totalSeconds);
  }
}