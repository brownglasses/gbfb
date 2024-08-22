import 'package:cached_network_image/cached_network_image.dart';
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

Widget commonCachedNetworkImage(
  String? url, {
  double? height,
  double? width,
  BoxFit? fit,
  AlignmentGeometry? alignment,
  bool usePlaceholderIfUrlEmpty = true,
  double? radius,
  Color? color,
}) {
  if (url!.validate().isEmpty) {
    return placeHolderWidget(
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      color: color,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(
            height: height,
            width: width,
            fit: fit,
            alignment: alignment,
            radius: radius);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return const SizedBox();
        return placeHolderWidget(
            height: height,
            width: width,
            fit: fit,
            alignment: alignment,
            radius: radius);
      },
    );
  } else {
    return Image.asset(url,
            height: height,
            width: width,
            fit: fit,
            alignment: alignment ?? Alignment.center)
        .cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget(
    {double? height,
    double? width,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    double? radius}) {
  return Image.asset('images/dating/placeholder.jpg',
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          alignment: alignment ?? Alignment.center)
      .cornerRadiusWithClipRRect(radius ?? defaultRadius);
}
