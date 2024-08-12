import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

InputDecoration buildInputDecoration({
  String? hintText,
  Widget? prefixIcon,
  Color? fillColor = Colors.white,
  Color? hintColor = Colors.grey,
  TextStyle? hintStyle,
  Color? borderColor = Colors.grey,
  double borderRadius = 8.0,
  double borderWidth = 0.5,
  EdgeInsetsGeometry? contentPadding =
      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
  bool filled = true,
  BorderSide? focusedBorderSide,
  BorderSide? enabledBorderSide,
}) {
  return InputDecoration(
    fillColor: fillColor,
    filled: filled,
    prefixIcon: prefixIcon,
    hintText: hintText,
    hintStyle: hintStyle ?? TextStyle(color: hintColor),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: focusedBorderSide ??
          BorderSide(color: borderColor!, width: borderWidth),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: enabledBorderSide ??
          BorderSide(color: borderColor!, width: borderWidth),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide.none,
    ),
    contentPadding: contentPadding,
  );
}
