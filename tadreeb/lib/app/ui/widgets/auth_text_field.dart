import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.controller,
    this.textInputAction,
    this.keyboardType,
    this.onSubmitted,
    this.suffix,
  });

  final String label;
  final String hint;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: obscureText,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}
