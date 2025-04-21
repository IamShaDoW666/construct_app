import 'package:digicon/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:digicon/constants/keys.dart';
import 'package:digicon/constants/routes.dart';
import 'package:digicon/services/api_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({
    super.key,
  });

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
    final themeProvider = Provider.of<ThemeProvider>(context);
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
            icon: !themeProvider.isDarkMode ? Icon(Icons.dark_mode) : Icon(Icons.light_mode),
            onPressed: () {
              themeProvider.toggleTheme();        
              setState(() {
                
              });      
            },
          ),
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
        child: GestureDetector(
          onTap: () {
            context.push(AppRoutes.imageList);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("View Batches", style: context.textTheme.headlineSmall),
              Icon(Icons.image, size: 100),
            ],
          ),
        ).paddingAll(32),
      ),
    );
  }
}
