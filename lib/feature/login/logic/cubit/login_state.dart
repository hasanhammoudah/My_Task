import 'package:task_progress_soft/feature/login/data/models/login_models.dart';

class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final CustomUser? user;

  LoginState({this.isLoading = false, this.errorMessage, this.user});
}

// Subclass for loading state
class LoginLoading extends LoginState {
  LoginLoading() : super(isLoading: true);
}

// Subclass for success state
class LoginSuccess extends LoginState {
  LoginSuccess(CustomUser user) : super(isLoading: false, user: user);
}

// Subclass for error state
class LoginError extends LoginState {
  LoginError(String errorMessage) : super(isLoading: false, errorMessage: errorMessage);
}
