import 'package:go_router/go_router.dart';
import 'package:playbilld/src/home_feature/home_view.dart';
import 'package:playbilld/src/models/show.dart';
import 'package:playbilld/src/settings/settings_view.dart';
import 'package:playbilld/src/shared/show_detail_view.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsView(),
    ),
    GoRoute(
      path: '/show_details',
      builder: (context, state) {
        final show = state.extra as Show;
        return ShowDetailView(show: show);
      },
    ),
  ],
);
