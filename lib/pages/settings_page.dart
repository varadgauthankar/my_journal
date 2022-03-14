import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/providers/auth_provider.dart';
import 'package:my_journal/providers/theme_provider.dart';
import 'package:my_journal/utils/helpers.dart';
import 'package:my_journal/widgets/my_card.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Widget> buildDarkModeChips(ThemeProvider value) {
    List<Widget> choices = [];
    for (var theme in ThemeMode.values) {
      choices.add(Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ChoiceChip(
          backgroundColor: getColorScheme(context).tertiaryContainer,
          selectedColor: getColorScheme(context).primary,
          elevation: 2,
          label: Text(theme.name),
          selected: value.themeMode == theme,
          onSelected: (selected) {
            value.setTheme(theme);
          },
        ),
      ));
    }
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(EvaIcons.arrowBack),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        children: [
          _profileCard(),
          _appThemeCard(),
        ],
      ),
    );
  }

  Consumer<ThemeProvider> _appThemeCard() {
    return Consumer<ThemeProvider>(
      builder: (context, value, child) {
        return MyCard(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'App Theme',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              spacer(height: 4),
              Wrap(
                children: buildDarkModeChips(value),
              )
            ],
          ),
        );
      },
    );
  }

  Consumer<AuthProvider> _profileCard() {
    return Consumer<AuthProvider>(builder: (context, value, child) {
      final user = value.getCurrentUser();
      return MyCard(
        onTap: () {},
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user!.photoURL!),
            ),
            spacer(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  user.email!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            TextButton(
              onPressed: () =>
                  value.signOut().then((value) => Navigator.pop(context)),
              child: const Text('LOG OUT'),
              style: TextButton.styleFrom(
                primary: Theme.of(context).colorScheme.error,
              ),
            )
          ],
        ),
      );
    });
  }
}
