import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:digicon/constants/keys.dart';
import 'package:digicon/constants/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), checkAuth);
  }

  void checkAuth() {
    String? token = getStringAsync(Constants.jwtKey);
    try {
      bool isAuthenticated =
          token.isNotEmpty &&
          !JwtDecoder.isExpired(
            token,
          ); // Use JwtDecoder from jwt_decoder package
      if (isAuthenticated) {
        setValue(Constants.user, JwtDecoder.decode(token)!['name']);
        context.go(AppRoutes.batches);
      } else {
        context.go(AppRoutes.login);
      }
    } catch (e) {
      // Handle JWT decoding error
      print("JWT decoding error: $e");
      removeKey(Constants.jwtKey);
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/icon/app_icon.png'),
          ).paddingSymmetric(horizontal: 24),
          32.height,
          CircularProgressIndicator.adaptive(
            backgroundColor: context.primaryColor,
          ).center().paddingAll(16),
        ],
      ),
    );
  }
}
