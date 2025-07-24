
import 'dart:async';

class TimerStateManager {
  static final Map<String, TimerState> _timers = {};
  static final Map<String, Function()> _completionCallbacks = {};
  static Timer? _globalTimer;
  // static final Map<String, VoidCallback> _lifecycleDisposers = {};

  static void saveTimerState(String key, TimerState state) {
    _timers[key] = state;
    if (!state.isCompleted) {
      _startGlobalTimer();
    }
  }

  static TimerState? getTimerState(String key) {
    final state = _timers[key];
    if (state != null && !state.isCompleted && state.isCompletedByTime) {
      _timers[key] = state.copyWith(isCompleted: true, isRunning: false);
      _completionCallbacks[key]?.call();
      return _timers[key];
    }
    return state;
  }

  // static void registerLifecycleDisposer(String key, VoidCallback disposer) {
  //   _lifecycleDisposers[key] = disposer;
  // }
  // static void disposeAllLifecycles() {
  //   for (final disposer in _lifecycleDisposers.values) {
  //     disposer();
  //   }
  //   _lifecycleDisposers.clear();
  // }

  static void setCompletionCallback(String key, Function() callback) {
    _completionCallbacks[key] = callback;
  }

  static void markAsCompleted(String key) {
    final state = _timers[key];
    if (state != null) {
      _timers[key] = state.copyWith(isCompleted: true, isRunning: false);
    }
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
    _completionCallbacks.clear();
  }

  static void stopAllExcept(String keyToKeep) {
    final keysToRemove = _timers.keys.where((k) => k != keyToKeep).toList();
    for (final key in keysToRemove) {
      _timers.remove(key);
      _completionCallbacks.remove(key);
    }
  }

  static void _startGlobalTimer() {
    if (_globalTimer != null) return;

    _globalTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      final completedKeys = <String>[];

      for (final entry in _timers.entries) {
        if (!entry.value.isCompleted && entry.value.isCompletedByTime) {
          completedKeys.add(entry.key);
        }
      }

      for (final key in completedKeys) {
        markAsCompleted(key);
        _completionCallbacks[key]?.call();
      }
      final hasActiveTimers = _timers.values.any((state) => !state.isCompleted);
      if (!hasActiveTimers) {
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
  final bool isCompleted;

  TimerState({
    required this.startTime,
    required this.totalSeconds,
    required this.isRunning,
    this.isCompleted = false,
  });

  double get progress {
    if (isCompleted) return 1.0;
    if (!isRunning) return 0.0;

    final elapsed = DateTime.now().difference(startTime).inMilliseconds;
    final totalMs = totalSeconds * 1000;
    final progress = elapsed / totalMs;

    return progress.clamp(0.0, 1.0);
  }

  bool get isCompletedByTime => progress >= 1.0;

  int get remainingSeconds {
    if (isCompleted) return 0;
    if (!isRunning) return totalSeconds;

    final elapsed = DateTime.now().difference(startTime).inSeconds;
    final remaining = totalSeconds - elapsed;

    return remaining.clamp(0, totalSeconds);
  }
  TimerState copyWith({
    DateTime? startTime,
    int? totalSeconds,
    bool? isRunning,
    bool? isCompleted,
  }) {
    return TimerState(
      startTime: startTime ?? this.startTime,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      isRunning: isRunning ?? this.isRunning,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}