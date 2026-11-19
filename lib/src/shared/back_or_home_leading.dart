import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:playbilld/src/home_feature/home_view.dart';

/// Returns a fallback "Back to Discover" button when a route is opened
/// directly (e.g., via deep link or web URL) with no back stack.
/// Returns `null` when a normal back stack exists or no [GoRouter] is present,
/// allowing [AppBar] to render its default platform back button.
Widget? buildBackOrHomeLeading(BuildContext context) {
  final router = GoRouter.maybeOf(context);
  if (router == null || router.canPop()) {
    return null;
  }
  return IconButton(
    tooltip: 'Back to Discover',
    icon: const Icon(Icons.arrow_back),
    onPressed: () => router.go(HomeView.routeName),
  );
}
