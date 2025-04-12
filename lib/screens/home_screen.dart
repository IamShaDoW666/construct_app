import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quickpay/constants/keys.dart';
import 'package:quickpay/constants/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Hello, ${getStringAsync(Constants.user)}',
            style: context.textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
        ).paddingSymmetric(horizontal: 8, vertical: 16),
        actions: [
          IconButton(
            iconSize: 32,
            icon: const Icon(Icons.logout),
            onPressed: () {
              removeKey(Constants.jwtKey);
              context.go(AppRoutes.login);
              setState(() {});
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 100, color: Colors.black),
            const SizedBox(height: 20),
            Text(
              'Welcome to the Home Screen',
              style: context.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
