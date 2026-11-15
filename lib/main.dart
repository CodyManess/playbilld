import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'src/app.dart';
import 'src/reviews/theater_log_controller.dart';
import 'src/settings/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await Future.wait([
    container.read(themeModeProvider.notifier).loadSettings(),
    container.read(theaterLogProvider.notifier).loadLogs(),
  ]);

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}
