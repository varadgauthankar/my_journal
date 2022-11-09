import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final bool secondary;
  const LargeButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.secondary = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: secondary
              ? Theme.of(context).colorScheme.background
              : Theme.of(context).colorScheme.primary,
          foregroundColor: secondary
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onPrimary,
        ),
        child: Text(label),
      ),
    );
  }
}
