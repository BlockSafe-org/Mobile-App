import "package:flutter/material.dart";

class AmountInput extends StatelessWidget {
  AmountInput(
      {Key? key,
      required this.validator,
      required this.amount,
      this.inputType,
      required this.onChanged})
      : super(key: key);
  int amount;
  final String? Function(String?) validator;
  TextInputType? inputType;
  Function(String val) onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 60,
      child: TextFormField(
        validator: validator,
        onChanged: onChanged,
        initialValue: amount.toString(),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusColor: Colors.white,
            hintText: "Amount"),
      ),
    );
  }
}
