import 'package:flutter/material.dart';
import 'package:my_journal/utils/color_schemes.dart';

class PrimaryTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final String? hintText;

  const PrimaryTextField({
    Key? key,
    this.textEditingController,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        filled: true,
        fillColor: false
            ? darkColorScheme.primaryContainer
            : lightColorScheme.primaryContainer,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(18.0),
      ),
    );
  }
}
