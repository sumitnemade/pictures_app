import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      this.validator,
      this.width,
      this.fieldWidth,
      this.keyboardType,
      this.onChanged,
      this.enabled,
      this.hintText,
      this.obscureText,
      this.controller,
      this.maxLength})
      : super(key: key);
  final FormFieldValidator<String>? validator;
  final String? hintText;
  final double? width;
  final double? fieldWidth;
  final bool? obscureText;
  final bool? enabled;
  final int? maxLength;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: width,
      height: 50,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(7)),
      child: TextFormField(
        obscureText: obscureText ?? false,
        controller: controller,
        enabled: enabled ?? true,
        onChanged: onChanged,
        validator: validator,
        maxLines: 1,
        maxLength: maxLength ?? 50,
        keyboardType: keyboardType ?? TextInputType.text,
        textAlign: TextAlign.left,
        style: const TextStyle(
          color: Colors.black45,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.3334423928571427,
        ),
        decoration: InputDecoration(
          hintText: hintText ?? "",
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          border: InputBorder.none,
          fillColor: Colors.white,
          counterText: "",
        ),
      ),
    );
  }
}
