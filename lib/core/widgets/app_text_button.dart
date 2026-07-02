import 'package:flutter/material.dart';

import '../theme/app_text_style.dart';



/// Inline tappable text link (e.g. "Forgot Password?").
///
/// Kept minimal and controlled — it exposes an [onPressed] and an overridable
/// [style], with no feature knowledge of its own.
class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style,
  });

  final String label;
  final VoidCallback? onPressed;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Text(label, style: style ?? AppTextStyles.link),
    );
  }
}