// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import '../constants.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    required this.prefixIcon,
    required this.keyboardType,
    this.onSaved,
    this.onChanged,
    this.obscureText = false,
    this.suffixIcon,
    this.suffixIconPressed,
    this.maxLines = 1,
  });

  final TextEditingController textEditingController;
  final String hintText;
  final Icon prefixIcon;
  final IconData? suffixIcon;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final TextInputType keyboardType;
  final bool obscureText;
  final void Function()? suffixIconPressed;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      scrollPadding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).viewInsets.bottom + 100,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      controller: textEditingController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      obscureText: obscureText,
      onSaved: (value) {},
      onChanged: (value) {},
      decoration: InputDecoration(
        border: buildOutlineInputBorder(),
        enabledBorder: buildOutlineInputBorder(),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: kSecondaryColor,
          fontSize: 12,
        ),
        prefixIcon: prefixIcon,
        prefixIconColor: kSecondaryColor,
        suffixIconColor: kSecondaryColor,
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: suffixIconPressed,
                icon: Icon(suffixIcon),
              )
            : null,
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          width: 2,
          color: kSecondaryColor,
        ));
  }
}
