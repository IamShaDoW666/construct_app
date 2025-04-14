import 'package:digicon/data/models.dart';
import 'package:digicon/screens/image_grid_picker_screen.dart';
import 'package:digicon/screens/image_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:digicon/constants/keys.dart';
import 'package:digicon/constants/routes.dart';
import 'package:digicon/screens/home_screen.dart';
import 'package:digicon/screens/image_list_screen.dart';
import 'package:digicon/screens/image_screen.dart';
import 'package:digicon/screens/login_screen.dart';
import 'package:digicon/screens/splash_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(path: AppRoutes.login, builder: (context, state) => LoginScreen()),
    GoRoute(path: AppRoutes.home, builder: (context, state) => HomeScreen()),
    GoRoute(path: AppRoutes.image, builder: (context, state) => ImagePickerScreen()),
    GoRoute(path: AppRoutes.imageList, builder: (context, state) => ImageListScreen()),
    GoRoute(path: AppRoutes.imageGridPicker, builder: (context, state) => ImageGridPickerScreen()),
    GoRoute(path: AppRoutes.imageGridView, builder: (context, state) => ImageGridView(batch: state.extra as Batch)),
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
