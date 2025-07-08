
class TimerStateManager {
  static final Map<String, TimerState> _timers = {};

  static void saveTimerState(String key, TimerState state) {
    _timers[key] = state;
  }

  static TimerState? getTimerState(String key) {
    return _timers[key];
  }

  static void removeTimer(String key) {
    _timers.remove(key);
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

  bool get isCompleted => progress >= 1.0;

  int get remainingSeconds {
    if (!isRunning) return totalSeconds;

    final elapsed = DateTime.now().difference(startTime).inSeconds;
    final remaining = totalSeconds - elapsed;

    return remaining.clamp(0, totalSeconds);
  }
}