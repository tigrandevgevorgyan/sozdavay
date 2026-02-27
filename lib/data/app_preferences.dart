// import 'package:shared_preferences/shared_preferences.dart';
//
// class AppPreferences {
//   static const _keyLockChanges = 'lock_changes';
//
//   final SharedPreferences _prefs;
//   AppPreferences(this._prefs);
//   //
//   // /// Удобная фабрика
//   // static Future<AppPreferences> create() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   return AppPreferences(prefs);
//   // }
//   //
//   // /// true — изменения ЗАПРЕЩЕНЫ, false — разрешены
//   // bool get isEditingLocked => _prefs.getBool(_keyLockChanges) ?? false;
//   //
//   // /// Установить запрет/разрешение
//   // Future<void> setEditingLocked(bool value) =>
//   //     _prefs.setBool(_keyLockChanges, value);
//   //
//   // /// Сбросить флаг (вернётся к значению по умолчанию = false)
//   // Future<void> clearEditingLocked() =>
//   //     _prefs.remove(_keyLockChanges);
// }