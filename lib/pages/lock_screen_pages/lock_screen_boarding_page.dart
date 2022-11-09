import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_journal/pages/home_page.dart';
import 'package:my_journal/pages/lock_screen_pages/create_pin_page.dart';

import 'package:my_journal/providers/pin_provider.dart';
import 'package:my_journal/utils/helpers.dart';
import 'package:my_journal/widgets/large_button.dart';
import 'package:provider/provider.dart';

class LockScreenBoardingPage extends StatelessWidget {
  const LockScreenBoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 44),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spacer(height: 66),
              SvgPicture.asset('assets/lock_light.svg', height: 100),
              spacer(height: 22),
              _topWords(context),
              const Spacer(),
              LargeButton(
                onPressed: () {
                  replacePage(context, page: const CreatePinPage());
                },
                label: 'Create PIN',
              ),
              LargeButton(
                secondary: true,
                onPressed: () {
                  replacePage(context, page: const HomePage());
                  Provider.of<PinProvider>(context, listen: false)
                      .skipPinCreation();
                },
                label: 'Continue without PIN',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _topWords(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Secure Journals',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        const Text(
          'Create a PIN to secure your journals.',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
