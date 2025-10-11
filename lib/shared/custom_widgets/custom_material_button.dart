// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import '../constants.dart';

class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({
    super.key,
    required this.onPressed,
    required this.buttonName,
    this.showIcon = false,
  });

  final VoidCallback? onPressed;
  final String buttonName;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonName,
              style: const TextStyle(fontSize: 24, color: kButtonsColor),
            ),
            if (showIcon == true)
              const SizedBox(
                width: 10,
              ),
            if (showIcon == true)
              const Icon(
                Icons.chat_outlined,
                color: kButtonsColor,
                size: 32,
              )
          ],
        ),
      ),
    );
  }
}
