import 'package:flutter/material.dart';
import 'package:rifqa/cores/utils/app_styles.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final int? maxLines;
  final Color? optionalColor;
  final void Function(String)? onFieldSubmitted;
  final Color? textColorStyle;
  final bool noVaidate;
  final double? padding;
  const CustomTextFieldWidget({
    super.key,
    required this.labelText,
    this.controller,
    this.obscureText,
    this.keyboardType,
    this.suffixIcon,
    this.maxLines,
    this.onFieldSubmitted,
    this.noVaidate = false,
    this.optionalColor,
    this.hintText,
    this.textColorStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: padding ?? 40.0, vertical: padding ?? 10),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          onFieldSubmitted: onFieldSubmitted,
          maxLines: obscureText ?? false ? 1 : maxLines,
          keyboardType: keyboardType,
          obscureText: obscureText ?? false,
          controller: controller,
          validator: noVaidate
              ? (value) {
                  return null;
                }
              : (value) {
                  if (value?.isEmpty ?? true) {
                    return "الرجاء ادخل الحقل";
                  } else {
                    return null;
                  }
                },
          style: AppStyles.styleText12
              .copyWith(color: textColorStyle ?? Colors.white),
          cursorColor: optionalColor ?? Colors.white,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
            labelText: labelText,
            hintStyle: AppStyles.styleText12
                .copyWith(color: optionalColor ?? Colors.white),
            labelStyle: AppStyles.styleText20
                .copyWith(color: optionalColor ?? Colors.white),
            enabledBorder: borderStyle(color: optionalColor),
            focusedBorder: borderStyle(color: optionalColor),
            errorBorder: borderStyle(color: Colors.red),
            focusedErrorBorder: borderStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder borderStyle({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color: color ?? Colors.white,
        width: 3,
      ),
    );
  }
}
