import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quickpay/constants/endpoints.dart';
import 'package:quickpay/constants/keys.dart';
import 'package:quickpay/constants/routes.dart';
import 'package:quickpay/services/network.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void handleLogin() async {
    setState(() {
      isLoading = true;
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      toast("Please enter username and password");
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await BaseApi().post(
        ApiEndpoints.login,
        data: {"email": email, "password": password},
      );
      print(response);
      if (response.statusCode == 200) {
        String token = response.data['data']['token'];
        setValue(Constants.jwtKey, token);
        setValue(Constants.user, response.data['data']['user']['name']);
        toast("Login successful");
        if (mounted) {
          context.go(AppRoutes.home);
        }
      } else {
        toast("Login failed");
      }
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        toast("Invalid credentials");
      } else if (e.statusCode == 500) {
        toast("Server error, please try again later");
      } else {
        toast("Error: ${e.message}");
      }
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            16.height,
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            16.height,
            ElevatedButton(
              onPressed: handleLogin,
              child: SizedBox(
                width: context.width() / 2,
                child: Center(
                  child: Text("Login", style: TextStyle(fontSize: 24)),
                ),
              ),
            ),
          ],
        ).paddingAll(36),
      ),
    );
  }
}
