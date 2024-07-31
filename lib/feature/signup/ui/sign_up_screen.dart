import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_progress_soft/core/helpers/spacing.dart';
import 'package:task_progress_soft/core/theming/styles.dart';
import 'package:task_progress_soft/core/widgets/app_text_button.dart';
import 'package:task_progress_soft/feature/signup/logic/cubit/register_cubit.dart';
import 'package:task_progress_soft/feature/signup/ui/widgets/already_have_account_text.dart';
import 'package:task_progress_soft/feature/signup/ui/widgets/sign_up_bloc_listener.dart';
import 'package:task_progress_soft/feature/signup/ui/widgets/sign_up_form.dart';


class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 60.h,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Account',
                      style: TextStyles.font24BlueBold,
                    ),
                    verticalSpace(8),
                    Text(
                      'Sign up now and start exploring all that our app has to offer. We\'re excited to welcome you to our community!',
                      style: TextStyles.font14GrayRegular,
                    ),
                    verticalSpace(36),
                    const SignupForm(),
                    verticalSpace(40),
                    AppTextButton(
                      buttonText: "Create Account",
                      textStyle: TextStyles.font16WhiteSemiBold,
                      onPressed: () {
                        validateThenDoSignup(context);
                      },
                    ),
                    verticalSpace(16),
                    verticalSpace(30),
                    const AlreadyHaveAccountText(),
                    const SignupBlocListener(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void validateThenDoSignup(BuildContext context) {
    final cubit = context.read<SignupCubit>();

    if (cubit.formKey.currentState?.validate() ?? false) {
      cubit.register(context);
    }
  }
}
