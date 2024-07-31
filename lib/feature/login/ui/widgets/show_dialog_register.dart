import 'package:flutter/material.dart';
import 'package:task_progress_soft/core/routing/routes.dart';

void showRegistrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User not registered'),
        content: const Text('Would you like to register?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, Routes.signUpScreen);
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
