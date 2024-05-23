import 'package:automated_texbook_system/utill/colors.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget placeholder;
  const AppButton(
      {super.key, required this.onPressed, required this.placeholder});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 60),
        backgroundColor: AppColor.textColor,
        shadowColor: AppColor.backgroundColor,
        elevation: 10,
      ),
      child: placeholder,
    );
  }
}
