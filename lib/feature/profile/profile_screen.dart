import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_progress_soft/core/helpers/spacing.dart';
import 'package:task_progress_soft/core/routing/routes.dart';
import 'package:task_progress_soft/core/theming/styles.dart';
import 'package:task_progress_soft/core/widgets/app_text_button.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: const SizedBox.shrink(),
        excludeHeaderSemantics: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQK4FSq5Ki3UsXg6t5zuHPCDWS4-EQJpkFdqg&s', // Replace with your image URL
                ),
              ),
            ),
            verticalSpace(16),
            // Example user data
            Text(
              'Name: ${'Guest'}',
              style: Theme.of(context).textTheme.headline6,
            ),
            verticalSpace(8),
            Text(
              'Mobile Number: ${'Not available'}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            verticalSpace(50),
            AppTextButton(
              buttonText: 'Logout',
              textStyle: TextStyles.font16WhiteSemiBold,
              onPressed: () async {
                await _logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await FlutterSecureStorage().deleteAll();
      Navigator.pushReplacementNamed(context, Routes.loginScreen);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: ${e.toString()}')),
      );
    }
  }
}
