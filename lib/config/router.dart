import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quickpay/constants/keys.dart';
import 'package:quickpay/constants/routes.dart';
import 'package:quickpay/screens/home_screen.dart';
import 'package:quickpay/screens/login_screen.dart';
import 'package:quickpay/screens/splash_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(path: AppRoutes.login, builder: (context, state) => LoginScreen()),
    GoRoute(path: AppRoutes.home, builder: (context, state) => HomeScreen()),
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
