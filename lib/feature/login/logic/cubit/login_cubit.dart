import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:task_progress_soft/core/routing/routes.dart';
import 'package:task_progress_soft/feature/login/logic/cubit/login_state.dart';
import 'package:task_progress_soft/feature/login/ui/widgets/show_dialog_register.dart';


class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  LoginCubit()
      : _firebaseAuth = FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance,
        super(LoginState());

  Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      // Check if user is registered
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        Navigator.pushReplacementNamed(context, Routes.homeScreen);

        //TODO: Save credentials for auto-login
      } else {
        showRegistrationDialog(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showRegistrationDialog(context);
      } else if (e.code == 'wrong-password') {
        // Show error message for incorrect password
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect password')),
        );
      } else {
        // Handle other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.message}')),
        );
      }
    }
  }
}
