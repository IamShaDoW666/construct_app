import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'config/router.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

