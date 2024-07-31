import 'package:flutter/foundation.dart';

@immutable
class SignupState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? errorMessage;
  final String? verificationId;

  SignupState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.errorMessage,
    this.verificationId,
  });

  SignupState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? errorMessage,
    String? verificationId,
  }) {
    return SignupState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      verificationId: verificationId ?? this.verificationId,
    );
  }
}

// Subclass for loading state
class SignupLoading extends SignupState {
  SignupLoading() : super(isLoading: true);
}

// Subclass for success state
class SignupSuccess extends SignupState {
  SignupSuccess(String verificationId) : super(isAuthenticated: true, verificationId: verificationId);
}

// Subclass for error state
class SignupError extends SignupState {
  SignupError(String errorMessage) : super(errorMessage: errorMessage);
}
