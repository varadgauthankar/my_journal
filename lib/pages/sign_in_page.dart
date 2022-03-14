import 'package:flutter/material.dart';
import 'package:my_journal/providers/auth_provider.dart';
import 'package:my_journal/utils/helpers.dart';
import 'package:my_journal/widgets/sign_in_with_google_button.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Consumer<AuthProvider>(builder: (context, value, child) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spacer(height: screenSize.height * .25),
              _topHeading(context),
              const Spacer(),
              GoogleSignInButton(
                onPressed: () => value.signInWithGoogle(),
              ),
              spacer(height: screenSize.height * .02),
            ],
          ),
        ),
      );
    });
  }

  Widget _topHeading(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hello,',
          style: TextStyle(
            fontSize: 40,
          ),
        ),
        Text(
          'Sign in',
          style: TextStyle(
            fontSize: 46,
            height: .9,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
