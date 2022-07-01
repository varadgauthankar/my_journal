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
              return SizedBox.shrink();
            }
          }),
      preferredSize: const Size.fromHeight(44),
    );
  }

  SliverToBoxAdapter _buildJournalStream(
    SettingsProvider settingsProvider,
    LabelsProvider labelsProvider,
    Size screenSize,
  ) {
    return SliverToBoxAdapter(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService!.journals!
            .where(
              'labels',
              arrayContainsAny: labelsProvider.selectedLabels.isEmpty
                  ? null
                  : labelsProvider.selectedLabels
                      .map((e) => e.toJson())
                      .toList(),
            )
            .orderBy(settingsProvider.sortBy.name, descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const ExceptionWidget(isError: true);
          }
          if (snapshot.data?.size == 0) {
            return const ExceptionWidget();
          }
          if (snapshot.hasData) {
            final journals =
                snapshot.data?.docs.map((e) => Journal.fromSnapshot(e));
            return _buildJournals(journals, screenSize);
          }
          //
          else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  _buildJournals(Iterable<Journal>? journals, Size screenSize) {
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
