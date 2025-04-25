import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:digicon/constants/endpoints.dart';
import 'package:digicon/constants/keys.dart';
import 'package:digicon/constants/routes.dart';
import 'package:digicon/services/network.dart';

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
    if (isLoading) return;
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
        setValue(Constants.userData, response.data['data']['user']);
        toast("Login successful");
        if (mounted) {
          context.go(AppRoutes.batches);
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
        toast("Request timed out");
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                16,
              ), // Adjust the radius as needed
              child: Image.asset(
                'assets/icon/app_icon.png',
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
            ),
            32.height,
            AutofillGroup(
              child: Column(
                children: [
                  TextField(
                    autofillHints: [AutofillHints.email],
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  16.height,
                  TextField(
                    controller: passwordController,
                    autofillHints: [AutofillHints.password],
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ],
              ),
            ),
            32.height,
            ElevatedButton(
              onPressed: handleLogin,
              child: SizedBox(
                width: context.width() / 2,
                height: 64,
                child: Center(
                  child:
                      !isLoading
                          ? const Text("Log in", style: TextStyle(fontSize: 24))
                          : const CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          ],
        ).paddingAll(36),
      ),
    );
  }
}
