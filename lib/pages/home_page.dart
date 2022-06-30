import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/pages/journal_page.dart';
import 'package:my_journal/pages/settings_page.dart';
import 'package:my_journal/providers/settings_provider.dart';
import 'package:my_journal/providers/tags_provider.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer2<SettingsProvider, TagsProvider>(
        builder: (context, settings, tags, _) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                floating: true,
                title: const Text('MyJournal'),
                actions: [
                  IconButton(
                    onPressed: () =>
                        goToPage(context, page: const SettingsPage()),
                    icon: const Icon(Icons.settings_outlined),
                  )
                ],
                bottom: _buildFilterChips(tags),
              ),
              _buildJournalStream(settings, tags, screenSize)
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

  PreferredSize _buildFilterChips(TagsProvider tags) {
    return PreferredSize(
      child: SizedBox(
        height: 44,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: FilterChip(
                selected: true,
                onSelected: (value) {},
                label: Text('helllo'),
              ),
            );
          },
        ),
      ),
      preferredSize: const Size.fromHeight(40),
    );
  }

  SliverToBoxAdapter _buildJournalStream(
    SettingsProvider settings,
    TagsProvider tagsProvider,
    Size screenSize,
  ) {
    return SliverToBoxAdapter(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService!.journals!
            .orderBy(settings.sortBy.name, descending: true)
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
