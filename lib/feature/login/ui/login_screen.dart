import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_progress_soft/feature/login/logic/cubit/login_cubit.dart';
import 'package:task_progress_soft/feature/login/logic/cubit/login_state.dart';
import 'package:task_progress_soft/feature/login/ui/widgets/dont_have_account_text.dart';
import 'package:task_progress_soft/feature/login/ui/widgets/login_bloc_listener.dart';
import 'package:task_progress_soft/feature/login/ui/widgets/phone_and_password.dart';
import 'package:task_progress_soft/feature/login/ui/widgets/terms_and_conditions_text.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/styles.dart';
import '../../../../core/widgets/app_text_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Image.asset('assets/images/logo.png'),
                ),
                verticalSpace(36),
                Column(
                  children: [
                    const PhoneAndPassword(),
                    verticalSpace(40),
                    BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        return AppTextButton(
                            buttonText: "Login",
                            textStyle: TextStyles.font16WhiteSemiBold,
                            onPressed: () {
                              validateThenDoLogin(context);
                            });
                      },
                    ),
                    verticalSpace(16),
                    const TermsAndConditionsText(),
                    verticalSpace(40),
                    const DontHaveAccountText(),
                    const LoginBlocListener(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validateThenDoLogin(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    final phoneNumber = cubit.phoneNumberController.text;
    final password = cubit.passwordController.text;

    if (cubit.formKey.currentState?.validate() ?? false) {
      cubit.login(phoneNumber, password, context);
    } else {
      print("Form validation failed");
    }
  }
}
