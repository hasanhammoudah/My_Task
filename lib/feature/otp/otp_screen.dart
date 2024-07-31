import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:task_progress_soft/core/routing/routes.dart';
import 'package:task_progress_soft/core/theming/styles.dart';
import 'package:task_progress_soft/core/widgets/app_text_button.dart';
import 'package:task_progress_soft/feature/signup/data/models/register_models.dart';
import 'package:task_progress_soft/feature/signup/logic/cubit/register_cubit.dart';
import 'package:task_progress_soft/feature/signup/logic/cubit/register_state.dart';


class OtpScreen extends StatefulWidget {
  final Register user;
  final String verificationId; // Add this parameter to receive verification ID

  const OtpScreen({
    Key? key,
    required this.user,
    required this.verificationId,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onOtpChange(String value, int index) {
    if (value.length == 1 && index < _controllers.length - 1) {
      FocusScope.of(context).nextFocus();
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).previousFocus();
    }
  }

  void _submitOtp() {
    final otp = _controllers.map((controller) => controller.text).join();
    if (otp.length == _controllers.length) {
      context.read<SignupCubit>().signInWithOtp(
            widget.verificationId,
            otp,
            widget.user,
            context
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
      ),
      body: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          } else if (state.isAuthenticated) {
            Navigator.pushReplacementNamed(context, Routes.homeScreen);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Please enter the 6-digit OTP sent to your phone',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    _controllers.length,
                    (index) => SizedBox(
                      width: 50,
                      child: TextField(
                        controller: _controllers[index],
                        autofocus: index == 0,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],
                        onChanged: (value) => _onOtpChange(value, index),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (state.isLoading) const CircularProgressIndicator(),
                AppTextButton(
                  onPressed: _submitOtp,
                  buttonText: 'Submit',
                  textStyle: TextStyles.font16WhiteSemiBold,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
