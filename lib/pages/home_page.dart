import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/pages/journal_page.dart';
import 'package:my_journal/pages/settings_page.dart';
import 'package:my_journal/providers/settings_provider.dart';
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

  _buildJournals(Iterable<Journal>? journals, Size screenSize) {
    if (screenSize.width > 768) {
      return GridView.builder(
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyJournal'),
        actions: [
          IconButton(
            onPressed: () => goToPage(context, page: const SettingsPage()),
            icon: const Icon(Icons.settings_outlined),
          )
        ],
      ),
      //
      body: Consumer<SettingsProvider>(
        builder: (context, value, _) {
          return StreamBuilder<QuerySnapshot>(
            stream: _firestoreService!.journals!
                .orderBy(value.sortBy.name, descending: true)
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
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => goToPage(context, page: const JournalPage()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
