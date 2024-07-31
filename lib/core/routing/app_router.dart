import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:task_progress_soft/core/routing/routes.dart';
import 'package:task_progress_soft/feature/home/bottom_navigation.dart';
import 'package:task_progress_soft/feature/home/logic/cubit/posts_cubit.dart';
import 'package:task_progress_soft/feature/login/logic/cubit/login_cubit.dart';
import 'package:task_progress_soft/feature/login/ui/login_screen.dart';
import 'package:task_progress_soft/feature/otp/otp_screen.dart';
import 'package:task_progress_soft/feature/signup/logic/cubit/register_cubit.dart';
import 'package:task_progress_soft/feature/signup/ui/sign_up_screen.dart';
import 'package:task_progress_soft/feature/splash_screen.dart'; // Ensure Dio is imported


class AppRouter {
  final Dio dio; // Declare Dio as a dependency

  AppRouter(this.dio); // Initialize Dio in the constructor

  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => LoginCubit(),
            child: const LoginScreen(),
          ),
        );
      case Routes.otpScreen:
        if (arguments is Map<String, dynamic>) {
          final verificationId = arguments['verificationId'] as String?;
          final user = arguments['user'];

          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => SignupCubit(), // Provide your OTP Cubit
              child: OtpScreen(
                verificationId: verificationId ?? '',
                user: user,
              ),
            ),
          );
        }
        return _errorRoute();
      case Routes.signUpScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => SignupCubit(), // Provide your Signup Cubit
            child: const SignupScreen(),
          ),
        );
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => PostCubit(dio)..fetchPosts(), // Pass Dio instance
            child: HomeScreen(),
          ),
        );
      default:
        return _errorRoute();
    }
  }

  Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('Error: Page not found'),
        ),
      ),
    );
  }
}
