import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:playbilld/src/settings/settings_controller.dart';
import 'package:playbilld/src/settings/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeSettingsService extends SettingsService {
  _FakeSettingsService(this._storedMode);

  ThemeMode _storedMode;

  @override
  Future<ThemeMode> themeMode() async => _storedMode;

  @override
  Future<void> updateThemeMode(ThemeMode theme) async {
    _storedMode = theme;
  }
}

void main() {
  group('SettingsService', () {
    test('defaults to ThemeMode.system and persists updates', () async {
      SharedPreferences.setMockInitialValues({});
      final service = SettingsService();

      expect(await service.themeMode(), ThemeMode.system);

      await service.updateThemeMode(ThemeMode.dark);
      expect(await service.themeMode(), ThemeMode.dark);
    });

    test(
      'falls back to ThemeMode.system for unrecognized stored values',
      () async {
        SharedPreferences.setMockInitialValues({'theme_mode': 'invalid'});
        final service = SettingsService();

        expect(await service.themeMode(), ThemeMode.system);
      },
    );
  });

  group('ThemeModeNotifier', () {
    test('defaults to ThemeMode.system and loads persisted mode', () async {
      final fakeService = _FakeSettingsService(ThemeMode.dark);
      final container = ProviderContainer(
        overrides: [settingsServiceProvider.overrideWithValue(fakeService)],
      );
      addTearDown(container.dispose);

      expect(container.read(themeModeProvider), ThemeMode.system);

      await container.read(themeModeProvider.notifier).loadSettings();
      expect(container.read(themeModeProvider), ThemeMode.dark);
    });

    test('updates state and persists via SettingsService', () async {
      final fakeService = _FakeSettingsService(ThemeMode.system);
      final container = ProviderContainer(
        overrides: [settingsServiceProvider.overrideWithValue(fakeService)],
      );
      addTearDown(container.dispose);

      await container
          .read(themeModeProvider.notifier)
          .updateThemeMode(ThemeMode.light);

      expect(container.read(themeModeProvider), ThemeMode.light);
      expect(await fakeService.themeMode(), ThemeMode.light);
    });
  });
}
