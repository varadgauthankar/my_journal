import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/models/label.dart';
import 'package:my_journal/pages/journal_page.dart';
import 'package:my_journal/pages/settings_page.dart';
import 'package:my_journal/providers/settings_provider.dart';
import 'package:my_journal/providers/labels_provider.dart';
import 'package:my_journal/services/firestore_service.dart';
import 'package:my_journal/utils/helpers.dart';
import 'package:my_journal/widgets/exception_widget.dart';
import 'package:my_journal/widgets/journal_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirestoreService? _firestoreService;

  @override
  void initState() {
    _firestoreService = FirestoreService();
    _firestoreService?.moveFireStoreCollection();
    _checkForLabels();
    super.initState();
  }

  void _checkForLabels() {
    _firestoreService?.labels?.snapshots().listen((event) {
      if (event.docs.isNotEmpty) {
        Provider.of<LabelsProvider>(context, listen: false)
            .setLabelsExist(true);
      } else {
        Provider.of<LabelsProvider>(context, listen: false)
            .setLabelsExist(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer2<SettingsProvider, LabelsProvider>(
        builder: (context, settingsProvider, labelsProvider, _) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: labelsProvider.isLabelsExist == true,
                title: const Text('MyJournal'),
                actions: [
                  IconButton(
                    onPressed: () =>
                        goToPage(context, page: const SettingsPage()),
                    icon: const Icon(Icons.settings_outlined),
                  )
                ],
                bottom: labelsProvider.isLabelsExist
                    ? _buildFilterChips(labelsProvider)
                    : null,
              ),
              _buildJournalStream(settingsProvider, labelsProvider, screenSize)
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToPage(context, page: const JournalPage()),
        child: const Icon(Icons.add),
      ),
    );
  }

  PreferredSize _buildFilterChips(LabelsProvider labelsProvider) {
    return PreferredSize(
      child: StreamBuilder<QuerySnapshot>(
          stream: _firestoreService!.labels!.snapshots(),
          builder: (context, snapshot) {
            // if data is present
            if (snapshot.hasData) {
              final labels =
                  snapshot.data?.docs.map((e) => Label.fromSnapshot(e));
              return SizedBox(
                height: 40,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: labels?.length,
                  itemBuilder: (context, index) {
                    final label = labels?.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: FilterChip(
                        selectedColor: Theme.of(context).colorScheme.primary,
                        checkmarkColor: Theme.of(context).colorScheme.onPrimary,
                        labelStyle: TextStyle(
                          color: labelsProvider.selectedLabels.contains(label)
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                        ),
                        selected: labelsProvider.selectedLabels.contains(label),
                        onSelected: (selected) {
                          if (selected) {
                            labelsProvider.addLabel(label!);
                          } else {
                            labelsProvider.removeLabel(label!);
                          }
                        },
                        label: Text(label?.label ?? ''),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
      preferredSize: const Size.fromHeight(44),
    );
  }

  Widget _buildJournalStream(
    SettingsProvider settingsProvider,
    LabelsProvider labelsProvider,
    Size screenSize,
  ) {
    return SliverToBoxAdapter(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService!.journals!
            // sorting journal based on labels
            .where(
              'labels',
              arrayContainsAny: labelsProvider.selectedLabels.isEmpty
                  ? null
                  : labelsProvider.selectedLabels
                      .map((e) => e.toJson())
                      .toList(),
            )

            // sorting journal based on created or updated time
            .orderBy(settingsProvider.sortBy.name, descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
                height: screenSize.height * .7,
                child: const Center(child: CircularProgressIndicator()));
          }

          // error state
          if (snapshot.hasError) {
            return SizedBox(
              height: screenSize.height * .7,
              child: const ExceptionWidget(isError: true),
            );
          }

          // empty state
          if (snapshot.data?.size == 0) {
            return SizedBox(
                height: screenSize.height * .7, child: const ExceptionWidget());
          }

          // journals state
          if (snapshot.hasData) {
            final journals =
                snapshot.data?.docs.map((e) => Journal.fromSnapshot(e));
            return _buildJournals(journals, screenSize);
          }

          // else
          else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildJournals(Iterable<Journal>? journals, Size screenSize) {
    // for desktops
    if (screenSize.width > 768) {
      return GridView.builder(
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        itemCount: journals?.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 110,
        ),
        itemBuilder: (context, index) {
          final journal = journals?.elementAt(index);
          final decryptedJournal = Journal.decrypt(journal!);
          return JournalCard(decryptedJournal);
        },
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        physics: const BouncingScrollPhysics(),
        itemCount: journals?.length,
        itemBuilder: ((context, index) {
          final journal = journals?.elementAt(index);
          final decryptedJournal = Journal.decrypt(journal!);
          return JournalCard(decryptedJournal);
        }),
      );
    }
  }
}
