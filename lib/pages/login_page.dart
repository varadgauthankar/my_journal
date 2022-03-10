import 'package:flutter/material.dart';
import 'package:my_journal/pages/register_page.dart';
import 'package:my_journal/utils/color_schemes.dart';
import 'package:my_journal/utils/helpers.dart';
import 'package:my_journal/widgets/primary_button.dart';
import 'package:my_journal/widgets/primary_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacer(height: screenSize.height * .25),
            _topHeading(),
            const Spacer(),
            const PrimaryTextField(
              hintText: 'Email Address',
            ),
            spacer(height: 6.0),
            const PrimaryTextField(
              hintText: 'Password',
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('Forgot Password?'),
              ),
            ),
            PrimaryButton(
              onPressed: () {},
              text: 'login',
            ),
            spacer(height: 50),
            Center(
              child: TextButton(
                onPressed: () =>
                    replacePage(context, page: const RegisterPage()),
                child: const Text('Don\'t have an account? Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topHeading() {
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
          'Login',
          style: TextStyle(
            fontSize: 46,
            height: .9,
            fontWeight: FontWeight.bold,
            color: false ? darkColorScheme.primary : lightColorScheme.primary,
          ),
        ),
      ],
    );
  }
}
