import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_progress_soft/core/helpers/app_regex.dart';
import 'package:task_progress_soft/core/helpers/spacing.dart';
import 'package:task_progress_soft/core/theming/styles.dart';
import 'package:task_progress_soft/core/widgets/app_text_form_field.dart';
import 'package:task_progress_soft/feature/login/ui/widgets/password_validations.dart';
import 'package:task_progress_soft/feature/signup/logic/cubit/register_cubit.dart';


class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool isPasswordObscureText = true;
  bool isPasswordConfirmationObscureText = true;

  bool hasLowercase = false;
  bool hasUppercase = false;
  bool hasSpecialCharacters = false;
  bool hasNumber = false;
  bool hasMinLength = false;
  String _countryCode = '+962'; // Default country code
  String? _selectedGender;
  int _age = 26;
  final List<String> _genders = ['Male', 'Female'];
  final List<int> _ages = List<int>.generate(
      100, (i) => i + 1); // Generates a list of ages from 1 to 100

  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    passwordController = context.read<SignupCubit>().passwordController;
    setupPasswordControllerListener();
  }

  void setupPasswordControllerListener() {
    passwordController.addListener(() {
      setState(() {
        hasLowercase = AppRegex.hasLowerCase(passwordController.text);
        hasUppercase = AppRegex.hasUpperCase(passwordController.text);
        hasSpecialCharacters =
            AppRegex.hasSpecialCharacter(passwordController.text);
        hasNumber = AppRegex.hasNumber(passwordController.text);
        hasMinLength = AppRegex.hasMinLength(passwordController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<SignupCubit>().formKey,
      child: Column(
        children: [
          AppTextFormField(
            hintText: 'Full name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid name';
              }
              return null;
            },
            controller: context.read<SignupCubit>().nameController,
          ),
          verticalSpace(18),
          _buildPhoneNumberField(),
          verticalSpace(18),
          _buildAgeFieldWithDropdown(),
          verticalSpace(18),
          AppTextFormField(
            controller: context.read<SignupCubit>().passwordController,
            hintText: 'Password',
            isObscureText: isPasswordObscureText,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isPasswordObscureText = !isPasswordObscureText;
                });
              },
              child: Icon(
                isPasswordObscureText ? Icons.visibility_off : Icons.visibility,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid password';
              }
              return null;
            },
          ),
          verticalSpace(18),
          _buildGenderDropdown(),
          verticalSpace(18),
          AppTextFormField(
            controller: context.read<SignupCubit>().passwordConfirmationController,
            hintText: 'Password Confirmation',
            isObscureText: isPasswordConfirmationObscureText,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isPasswordConfirmationObscureText = !isPasswordConfirmationObscureText;
                });
              },
              child: Icon(
                isPasswordConfirmationObscureText
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid password confirmation';
              }
              if (value != passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          verticalSpace(24),
          PasswordValidations(
            hasLowerCase: hasLowercase,
            hasUpperCase: hasUppercase,
            hasSpecialCharacters: hasSpecialCharacters,
            hasNumber: hasNumber,
            hasMinLength: hasMinLength,
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return Row(
      children: [
        Text(
          _countryCode,
          style: TextStyles.font14DarkBlueMedium,
        ),
        SizedBox(width: 8.w), // Adjust the spacing as needed
        Expanded(
          child: AppTextFormField(
            controller: context.read<SignupCubit>().phoneController,
            hintText: 'Enter your phone number',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAgeFieldWithDropdown() {
    return Stack(children: [
      AppTextFormField(
        controller: context.read<SignupCubit>().ageController
          ..text = _age.toString(),
        hintText: 'Age',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select your age';
          }
          return null;
        },
        suffixIcon: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            hint: const Text('Enter your Age'),
            style: TextStyles.font12BlueRegular,
            icon: const Icon(Icons.arrow_drop_down),
            onChanged: (int? newValue) {
              setState(() {
                _age = newValue!;
                context.read<SignupCubit>().ageController.text = _age.toString();
              });
            },
            items: _ages.map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
        ),
      ),
    ]);
  }

  Widget _buildGenderDropdown() {
    return AppTextFormField(
      hintText: 'Enter your Gender',
      controller: context.read<SignupCubit>().genderController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your gender';
        }
        return null;
      },
      suffixIcon: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Text(''),
          value: _selectedGender,
          items: _genders.map((gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(gender),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedGender = value;
              context.read<SignupCubit>().genderController.text = value!;
            });
          },
          icon: const Icon(Icons.arrow_drop_down),
          underline: const SizedBox(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }
}
