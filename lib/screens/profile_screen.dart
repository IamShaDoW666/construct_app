import 'package:digicon/constants/keys.dart';
import 'package:digicon/constants/routes.dart';
import 'package:digicon/data/models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Picture
              SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  user.profile != null
                      ? '${Constants.baseUrl}${user.profile}'
                      : "https://avatar.iran.liara.run/public/26",
                ),
              ),
              SizedBox(height: 10),
              // Name
              Text(
                user.name!,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              // Location
              Text(
                user.role,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 10),
              // Bio
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  user.email,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (user.batches != null)
                    _buildStatColumn('Batches', user.batches!.length),
                  if (user.media != null)
                    _buildStatColumn('Media', user.media!.length),
                ],
              ),
              SizedBox(height: 20),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Implement contact functionality
                  //   },
                  //   child: Text('Change Password'),
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      removeKey(Constants.jwtKey);
                      context.go(AppRoutes.login);
                    },
                    child: Text('Logout'),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ).paddingTop(32),
      ),
    );
  }

  Widget _buildStatColumn(String label, int count) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }
}
