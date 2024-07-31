import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_progress_soft/core/routing/routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Firebase.initializeApp();
    await _loadConfiguration();
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, Routes.loginScreen);
  }

  Future<void> _loadConfiguration() async {
    try {
      DocumentSnapshot config = await FirebaseFirestore.instance
          .collection('configuration')
          .doc('system')
          .get();

      if (config.exists) {
        var mobileRegex = config['mobile_regex'];
        var passwordRegex = config['password_regex'];
        // Additional configuration can be loaded here
        print('Mobile Regex: $mobileRegex');
        print('Password Regex: $passwordRegex');
      } else {
        print('Configuration document does not exist.');
      }
    } catch (e) {
      print('Failed to load configuration: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          const Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Text(
              '© 2024 ProgressSoft',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
