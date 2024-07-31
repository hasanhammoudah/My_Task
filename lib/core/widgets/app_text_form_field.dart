import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_progress_soft/core/theming/colors.dart';
import 'package:task_progress_soft/core/theming/styles.dart';


class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.hintText,
    this.suffixIcon,
    this.focusedBorder,
    this.enabledBorder,
    this.hintStyle,
    this.isObscureText,
    this.contentPadding,
    this.inputTextStyle,
    this.backgroundColor,
    this.controller,
    this.prefixText,
    required this.validator,
    this.onChanged, // Added onChanged parameter
  });

  final String hintText;
  final Widget? suffixIcon;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? hintStyle;
  final bool? isObscureText;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? inputTextStyle;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final String? prefixText;
  final Function(String?) validator;
  final void Function(String)? onChanged; // Added onChanged parameter

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 18.h,
            ),
        focusedBorder: focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                16.0,
              ),
              borderSide: const BorderSide(
                color: ColorsManager.mainBlue,
                width: 1.3,
              ),
            ),
        enabledBorder: enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                16.0,
              ),
              borderSide: const BorderSide(
                color: ColorsManager.lightGray,
                width: 1.3,
              ),
            ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            16.0,
          ),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.3,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            16.0,
          ),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.3,
          ),
        ),
        hintStyle: hintStyle ?? TextStyles.font14LightGrayRegular,
        hintText: hintText,
        suffixIcon: suffixIcon,
        fillColor: backgroundColor ?? ColorsManager.moreLightGray,
        filled: true,
        prefixText: prefixText,
        prefixStyle: TextStyles.font14DarkBlueMedium,
      ),
      obscureText: isObscureText ?? false,
      style: TextStyles.font14DarkBlueMedium,
      validator: (value) {
        return validator(value);
      },
      onChanged: onChanged, // Added onChanged callback
    );
  }
}
