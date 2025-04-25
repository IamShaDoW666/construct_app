import 'package:digicon/constants/keys.dart';
import 'package:digicon/constants/routes.dart';
import 'package:digicon/data/models.dart';
import 'package:digicon/scaffold.dart';
import 'package:digicon/screens/home_screen.dart';
import 'package:digicon/screens/image_grid_picker_screen.dart';
import 'package:digicon/screens/image_grid_view.dart';
import 'package:digicon/screens/image_list_screen.dart';
import 'package:digicon/screens/login_screen.dart';
import 'package:digicon/screens/profile_screen.dart';
import 'package:digicon/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorAKey = GlobalKey<NavigatorState>();
final _shellNavigatorBKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(path: AppRoutes.login, builder: (context, state) => LoginScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNav(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorAKey,
          routes: [
            GoRoute(
              path: AppRoutes.batches,
              pageBuilder:
                  (context, state) =>
                      const NoTransitionPage(child: ImageListScreen()),
              routes: [
                GoRoute(
                  path: 'details',
                  builder:
                      (context, state) =>
                          ImageGridView(batch: state.extra as Batch),
                ),
                GoRoute(
                  path: 'create',
                  builder: (context, state) => const ImageGridPickerScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorBKey,
          routes: [
            GoRoute(
              path: AppRoutes.home,
              pageBuilder: (context, state) {
                final user = getJSONAsync(Constants.userData);
                User userData = User.fromJson(user);
                return NoTransitionPage(child: ProfileScreen(user: userData));
              },
              routes: [],
            ),
          ],
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    try {
      String? token = getStringAsync(Constants.jwtKey);
      bool isAuthenticated = token.isNotEmpty && !JwtDecoder.isExpired(token);
      setValue(Constants.user, JwtDecoder.decode(token)!['name']);
      if (state.fullPath == AppRoutes.home && !isAuthenticated) {
        return AppRoutes.login;
      }
      if (state.fullPath == AppRoutes.login && isAuthenticated) {
        return AppRoutes.home;
      }
    } catch (e) {
      // Handle JWT decoding error
      print("JWT decoding error: $e");
      removeKey(Constants.jwtKey);
      return AppRoutes.login;
    }
    return null;
  },
);
