import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'settings_service.dart';

part 'settings_controller.g.dart';

@Riverpod(keepAlive: true)
SettingsService settingsService(Ref ref) {
  return SettingsService();
}

@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  Future<void> loadSettings() async {
    final service = ref.read(settingsServiceProvider);
    state = await service.themeMode();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == state) return;

    state = newThemeMode;
    final service = ref.read(settingsServiceProvider);
    await service.updateThemeMode(newThemeMode);
  }
}
