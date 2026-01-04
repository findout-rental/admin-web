import 'package:flutter/material.dart';

class AppTextStyles {
  // Headings
  static TextStyle? heading1(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge?.copyWith(
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle? heading2(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle? heading3(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w600,
    );
  }

  // Body
  static TextStyle? bodyLarge(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge;
  }

  static TextStyle? bodyMedium(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium;
  }

  static TextStyle? bodySmall(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall;
  }

  // Labels
  static TextStyle? label(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w500,
    );
  }

  // Caption
  static TextStyle? caption(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Colors.grey[600],
    );
  }
}

