import 'package:flutter/material.dart';

class ProfileChip extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Color backgroundColor;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double spacing;
  final double runSpacing;

  const ProfileChip({
    super.key,
    required this.label,
    this.labelColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.fontSize = 10.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    this.borderRadius = 10.0,
    this.spacing = 0.0,
    this.runSpacing = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: labelColor,
          fontSize: fontSize,
        ),
      ),
      backgroundColor: backgroundColor,
      visualDensity: VisualDensity.compact,
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class ProfileChipList extends StatelessWidget {
  final List<String> labels;
  final Color labelColor;
  final Color backgroundColor;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double spacing;
  final double runSpacing;

  const ProfileChipList({
    super.key,
    required this.labels,
    this.labelColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.fontSize = 10.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    this.borderRadius = 10.0,
    this.spacing = 0.0,
    this.runSpacing = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: labels
            .map((label) => ProfileChip(
                  label: label,
                  labelColor: labelColor,
                  backgroundColor: backgroundColor,
                  fontSize: fontSize,
                  padding: padding,
                  borderRadius: borderRadius,
                ))
            .toList(),
      ),
    );
  }
}
