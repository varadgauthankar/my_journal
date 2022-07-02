import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/pages/manage_labels_page.dart';
import 'package:my_journal/providers/auth_provider.dart';
import 'package:my_journal/providers/settings_provider.dart';
import 'package:my_journal/providers/theme_provider.dart';
import 'package:my_journal/utils/helpers.dart';
import 'package:my_journal/utils/sort_by_options.dart';
import 'package:my_journal/widgets/my_card.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Widget> _buildDarkModeChips(ThemeProvider value) {
    List<Widget> choices = [];
    for (var theme in ThemeMode.values) {
      choices.add(Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ChoiceChip(
          backgroundColor: getColorScheme(context).tertiaryContainer,
          selectedColor: getColorScheme(context).primary,
          labelStyle: TextStyle(
            color: value.themeMode == theme
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onTertiaryContainer,
          ),
          elevation: 2,
          label: Text(theme.name.toFirstLetterCapital()),
          selected: value.themeMode == theme,
          onSelected: (selected) {
            value.setTheme(theme);
          },
        ),
      ));
    }
    return choices;
  }

  List<Widget> _buildSortByChips(SettingsProvider value) {
    List<Widget> choices = [];
    for (var sortBy in SortBy.values) {
      choices.add(Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ChoiceChip(
          backgroundColor: getColorScheme(context).tertiaryContainer,
          selectedColor: getColorScheme(context).primary,
          labelStyle: TextStyle(
            color: value.sortBy == sortBy
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onTertiaryContainer,
          ),
          elevation: 2,
          label: Text(sortBy.toMyString()),
          selected: value.sortBy == sortBy,
          onSelected: (selected) {
            value.setSortBy(sortBy);
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
          _journalSortCard(),
          _buildManageLabelsCard(),
        ],
      ),
    );
  }

  Widget _buildManageLabelsCard() {
    return MyCard(
        onTap: () {
          goToPage(context, page: const ManageLabels());
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Manage Labels',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const Icon(EvaIcons.chevronRight),
          ],
        ));
  }

  Widget _appThemeCard() {
    return Consumer<ThemeProvider>(
      builder: (context, value, child) {
        return MyCard(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'App theme',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              spacer(height: 4),
              Wrap(children: _buildDarkModeChips(value))
            ],
          ),
        );
      },
    );
  }

  Widget _journalSortCard() {
    return Consumer<SettingsProvider>(
      builder: (context, value, child) {
        return MyCard(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort journals by',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              spacer(height: 4),
              Wrap(children: _buildSortByChips(value))
            ],
          ),
        );
      },
    );
  }

  Widget _profileCard() {
    return Consumer<AuthProvider>(builder: (context, value, child) {
      final user = value.getCurrentUser();
      return MyCard(
        onTap: () {},
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user?.photoURL ?? ''),
              onBackgroundImageError: (obj, stack) {},
            ),
            spacer(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName ?? '',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  user?.email ?? '',
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
