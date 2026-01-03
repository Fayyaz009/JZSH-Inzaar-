import '../../core/db/app_database.dart';
import '../../core/db/tables.dart';
import '../models/settings.dart';

class PremiumRepository {
  PremiumRepository({required this.database});

  final AppDatabase database;

  Future<SettingsData> loadSettings() async {
    final result = await database.database.query(AppTables.settings, where: 'id = ?', whereArgs: [1]);
    if (result.isEmpty) {
      return const SettingsData(isPremium: false, musicOn: true, sfxOn: true);
    }
    final row = result.first;
    return SettingsData(
      isPremium: (row['isPremium'] as int) == 1,
      musicOn: (row['musicOn'] as int) == 1,
      sfxOn: (row['sfxOn'] as int) == 1,
    );
  }

  Future<void> setPremium(bool value) async {
    await database.database.update(
      AppTables.settings,
      {'isPremium': value ? 1 : 0},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  Future<void> setMusic(bool value) async {
    await database.database.update(
      AppTables.settings,
      {'musicOn': value ? 1 : 0},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  Future<void> setSfx(bool value) async {
    await database.database.update(
      AppTables.settings,
      {'sfxOn': value ? 1 : 0},
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}
