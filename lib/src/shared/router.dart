import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:playbilld/src/browse_feature/browse_view.dart';
import 'package:playbilld/src/diary_feature/diary_view.dart';
import 'package:playbilld/src/home_feature/home_view.dart';
import 'package:playbilld/src/mock/shows_provider.dart';
import 'package:playbilld/src/models/show.dart';
import 'package:playbilld/src/profile_feature/profile_view.dart';
import 'package:playbilld/src/settings/settings_view.dart';
import 'package:playbilld/src/shared/app_shell.dart';
import 'package:playbilld/src/shared/back_or_home_leading.dart';
import 'package:playbilld/src/shared/show_detail_view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  GoRouter.optionURLReflectsImperativeAPIs = true;
  final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    restorationScopeId: 'router',
    initialLocation: HomeView.routeName,
    routes: [
      StatefulShellRoute.indexedStack(
        restorationScopeId: 'shell',
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            restorationScopeId: 'discover',
            routes: [
              GoRoute(
                name: 'discover',
                path: HomeView.routeName,
                builder: (context, state) => const HomeView(),
              ),
            ],
          ),
          StatefulShellBranch(
            restorationScopeId: 'browse',
            routes: [
              GoRoute(
                name: 'browse',
                path: BrowseView.routeName,
                builder: (context, state) => const BrowseView(),
              ),
            ],
          ),
          StatefulShellBranch(
            restorationScopeId: 'diary',
            routes: [
              GoRoute(
                name: 'diary',
                path: DiaryView.routeName,
                builder: (context, state) => const DiaryView(),
              ),
            ],
          ),
          StatefulShellBranch(
            restorationScopeId: 'profile',
            routes: [
              GoRoute(
                name: 'profile',
                path: ProfileView.routeName,
                builder: (context, state) => const ProfileView(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        name: 'settings',
        parentNavigatorKey: rootNavigatorKey,
        path: SettingsView.routeName,
        builder: (context, state) => const SettingsView(),
      ),
      GoRoute(
        name: 'show-detail',
        parentNavigatorKey: rootNavigatorKey,
        path: '${ShowDetailView.routeName}/:id',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Show) {
            return ShowDetailView(show: extra);
          }
          final id = state.pathParameters['id'];
          if (id == null) {
            return const _MissingShowView();
          }
          return Consumer(
            builder: (context, ref, _) {
              final show = ref.watch(showByIdProvider(id));
              if (show == null) {
                return const _MissingShowView();
              }
              return ShowDetailView(show: show);
            },
          );
        },
      ),
    ],
    errorBuilder: (context, state) => const _MissingShowView(),
  );

  ref.onDispose(router.dispose);
  return router;
}

class _MissingShowView extends StatelessWidget {
  const _MissingShowView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: buildBackOrHomeLeading(context),
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('The requested page could not be found.'),
            const SizedBox(height: 16.0),
            FilledButton(
              onPressed: () => context.go(HomeView.routeName),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
