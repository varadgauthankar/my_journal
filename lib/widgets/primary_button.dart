import 'package:flutter/material.dart';
import 'package:my_journal/utils/color_schemes.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.maxFinite,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(text.toUpperCase()),
        style: TextButton.styleFrom(
          backgroundColor:
              false ? darkColorScheme.primary : lightColorScheme.primary,
          primary: false ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}
