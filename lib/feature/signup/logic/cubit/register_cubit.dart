import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_progress_soft/feature/signup/data/models/register_models.dart';
import 'package:task_progress_soft/feature/signup/logic/cubit/register_state.dart';
import '../../../../core/routing/routes.dart';

class SignupCubit extends Cubit<SignupState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  SignupCubit()
      : _firebaseAuth = FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance,
        super(SignupState());

  Future<void> verifyPhoneNumber(String phoneNumber, BuildContext context) async {
    emit(SignupState(isLoading: true));
    print("Verifying phone number: $phoneNumber");
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
        emit(SignupState(isAuthenticated: true));
      },
      verificationFailed: (FirebaseAuthException e) {
        emit(SignupState(errorMessage: e.message));
      },
      codeSent: (String verificationId, int? resendToken) {
        emit(SignupState(verificationId: verificationId));
        Navigator.pushNamed(context, Routes.otpScreen, arguments: {
          'verificationId': verificationId,
          'user': Register(
            age: ageController.text,
            gender: genderController.text,
            password: passwordController.text,
            fullName: nameController.text,
            phoneNumber: phoneController.text,
          ),
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        emit(SignupState(errorMessage: 'Timed out waiting for SMS. Please request a new code.'));
      },
    );
  }

  Future<void> signInWithOtp(String verificationId, String smsCode, Register user, BuildContext context) async {
    emit(SignupState(isLoading: true));
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

      await _firestore.collection('users').doc(userCredential.user!.uid).set(user.toMap());

      emit(SignupState(isAuthenticated: true));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration successful')));
      Navigator.pushReplacementNamed(context, Routes.loginScreen);
    } catch (e) {
      emit(SignupState(errorMessage: e.toString()));
    }
  }

  bool validateForm() {
    if (formKey.currentState!.validate()) {
      if (passwordController.text != passwordConfirmationController.text) {
        emit(SignupState(errorMessage: "Passwords do not match"));
        return false;
      }
      return true;
    } else {
      emit(SignupState(errorMessage: "Please fill all fields correctly"));
      return false;
    }
  }

  Future<void> register(BuildContext context) async {
    if (validateForm()) {
      String phoneNumber = phoneController.text.trim();
      if (phoneNumber.isEmpty) {
        emit(SignupState(errorMessage: "Phone number cannot be empty"));
        return;
      }
      await verifyPhoneNumber(phoneNumber, context);
    }
  }
}
