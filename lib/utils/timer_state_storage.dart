import 'package:shared_preferences/shared_preferences.dart';

class TimerStateStorage {
  static String _keyScheduled(int id) => 'timer_scheduled_$id';
  static String _keyTriggerTime(int id) => 'timer_trigger_time_$id';

  static Future<void> save(int id, DateTime time) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_keyScheduled(id), true);
    await sp.setInt(_keyTriggerTime(id), time.millisecondsSinceEpoch);
  }

  static Future<bool> wasTriggered(int id) async {
    final sp = await SharedPreferences.getInstance();
    final was = sp.getBool(_keyScheduled(id)) ?? false;
    final triggerTime = sp.getInt(_keyTriggerTime(id));
    if (!was || triggerTime == null) return false;
    return DateTime.now().millisecondsSinceEpoch >= triggerTime;
  }

  static Future<void> clear(int id) async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_keyScheduled(id));
    await sp.remove(_keyTriggerTime(id));
  }
}
