import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_progress_soft/core/routing/app_router.dart';
import 'package:task_progress_soft/core/routing/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  
  // Initialize Firebase
  await Firebase.initializeApp();

  final Dio dio = Dio();
  final AppRouter appRouter = AppRouter(dio);
  final secureStorage = FlutterSecureStorage();
  final firebaseAuth = FirebaseAuth.instance;

  // Check for stored credentials
  final email = await secureStorage.read(key: 'email');
  final password = await secureStorage.read(key: 'password');

  // If credentials are found, attempt auto-login
  if (email != null && password != null) {
    try {
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('Auto-login failed: $e');
      // Handle auto-login failure if necessary
    }
  }

  runApp(MyTask(appRouter: appRouter));
}

class MyTask extends StatelessWidget {
  const MyTask({super.key, required this.appRouter});
  
  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Progress Soft',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: FirebaseAuth.instance.currentUser != null
            ? Routes.homeScreen
            : Routes.onBoardingScreen,
        onGenerateRoute: appRouter.generateRoute,
      ),
    );
  }
}
