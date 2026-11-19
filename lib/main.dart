import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'src/app.dart';
import 'src/reviews/theater_log_controller.dart';
import 'src/settings/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint('Unhandled error: $error\n$stack');
    return kReleaseMode;
  };

  final container = ProviderContainer();
  await Future.wait([
    container.read(themeModeProvider.notifier).loadSettings(),
    container.read(theaterLogProvider.notifier).loadLogs(),
  ]);

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}
