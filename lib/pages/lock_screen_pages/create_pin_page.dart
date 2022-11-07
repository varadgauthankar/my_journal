// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:my_journal/pages/home_page.dart';
import 'package:my_journal/providers/pin_provider.dart';
import 'package:my_journal/utils/helpers.dart';
import 'package:my_journal/utils/validators.dart';
import 'package:provider/provider.dart';

class CreatePinPage extends StatelessWidget {
  const CreatePinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Consumer<PinProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Text(
                  'Create a PIN',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Text(
                  'To secure your journal',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: screenSize.width * 0.35,
                  child: Form(
                    key: provider.formKey,
                    child: TextFormField(
                      controller: provider.pinController,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(filled: true),
                      maxLength: 6,
                      validator: (value) => pinValidator(value),
                      onFieldSubmitted: (_) async {
                        final isPinCreated = await provider.createPin();
                        if (isPinCreated) {
                          replacePage(context, page: const HomePage());
                        } else {
                          showSnackbar(context,
                              provider.errorMessage ?? 'Something went wrong!');
                        }
                      },
                    ),
                  ),
                ),
                const Spacer(),
                provider.state == PinState.loading
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: myCircularProgressIndicator(size: 16))
                    : TextButton(
                        onPressed: () {},
                        child: const Text('Continue without PIN'),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
