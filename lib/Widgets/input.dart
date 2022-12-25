import "package:flutter/material.dart";

class InputData extends StatelessWidget {
  InputData(
      {Key? key,
      required this.validator,
      required this.controller,
      required this.isObscure,
      required this.hint,
      this.inputType})
      : super(key: key);

  final TextEditingController controller;
  final String hint;
  final String? Function(String?) validator;
  bool isObscure;
  TextInputType? inputType = null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 60,
      child: TextFormField(
        validator: validator,
        obscureText: isObscure,
        keyboardType: inputType != null ? inputType : TextInputType.text,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10)),
            focusColor: Colors.white,
            hintText: hint),
        controller: controller,
      ),
    );
  }
}
