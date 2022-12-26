import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          _profileCard(),
          _appThemeCard(),
          _buildShowFilterChips(),
          _journalSortCard(),
          _buildManageLabelsCard(),
        ],
      ),
    );
  }

  List<Widget> _buildDarkModeChips(ThemeProvider value) {
    List<Widget> choices = [];
    for (var theme in ThemeMode.values) {
      choices.add(Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ChoiceChip(
          labelStyle: TextStyle(
            color: value.themeMode == theme
                ? Theme.of(context).colorScheme.onTertiary
                : Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          // elevation: 2,
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

  Widget _buildShowFilterChips() {
    return Consumer<SettingsProvider>(
      builder: (context, myType, child) {
        return MyCard(
          onTap: () {
            myType.setShowFilterChips(!myType.showFilterChips);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Show Filter Chips',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: getColorScheme(context).onSurface,
                    ),
              ),
              FlutterSwitch(
                height: 34,
                width: 56,
                inactiveSwitchBorder: Border.all(
                  width: 3,
                  color: getColorScheme(context).secondary,
                ),
                activeColor: getColorScheme(context).primary,
                inactiveColor: getColorScheme(context).secondaryContainer,
                inactiveToggleColor: getColorScheme(context).secondary,
                value: myType.showFilterChips,
                onToggle: (value) {
                  myType.setShowFilterChips(value);
                },
              )
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildSortByChips(SettingsProvider value) {
    List<Widget> choices = [];
    for (var sortBy in SortBy.values) {
      choices.add(Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ChoiceChip(
          labelStyle: TextStyle(
            color: value.sortBy == sortBy
                ? Theme.of(context).colorScheme.onTertiary
                : Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          // elevation: 2,
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: getColorScheme(context).onSurface,
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: getColorScheme(context).onSurface,
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: getColorScheme(context).onSurface,
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: getColorScheme(context).onSurface,
                      ),
                ),
                Text(
                  user?.email ?? '',
                  style: Theme.of(context).textTheme.subtitle2?.copyWith(
                        color: getColorScheme(context).onSurface,
                      ),
                ),
              ],
            ),
            const Spacer(),
            TextButton(
              onPressed: () =>
                  value.signOut().then((value) => Navigator.pop(context)),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('LOG OUT'),
            )
          ],
        ),
      );
    });
  }
}
