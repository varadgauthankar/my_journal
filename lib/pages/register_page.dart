import 'package:flutter/material.dart';
import 'package:my_journal/utils/color_schemes.dart';
import 'package:my_journal/utils/helpers.dart';
import 'package:my_journal/widgets/primary_button.dart';
import 'package:my_journal/widgets/primary_text_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacer(height: screenSize.height * .25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello,',
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 46,
                    height: .9,
                    fontWeight: FontWeight.bold,
                    color: false
                        ? darkColorScheme.primary
                        : lightColorScheme.primary,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const PrimaryTextField(
              hintText: 'Email Address',
            ),
            spacer(height: 6.0),
            const PrimaryTextField(
              hintText: 'Password',
            ),
            spacer(height: 6.0),
            const PrimaryTextField(
              hintText: 'Confirm Password',
            ),
            spacer(height: 22.0),
            PrimaryButton(
              onPressed: () {},
              text: 'sign up',
            ),
            spacer(height: 50),
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text('Already have an account? Log In'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
