import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/utils/helpers.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  const GoogleSignInButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.maxFinite,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(EvaIcons.google),
            spacer(width: 12.0),
            const Text('Sign in with Google'),
          ],
        ),
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          primary: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
      ),
    );
  }
}
