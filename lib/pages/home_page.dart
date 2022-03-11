import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/pages/journal_page.dart';
import 'package:my_journal/services/firestore_service.dart';
import 'package:my_journal/utils/helpers.dart';
import 'package:my_journal/widgets/journal_card.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyJournal'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          )
        ],
      ),
      //
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService!.journals!.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Something went wrong!');
          }
          if (snapshot.data?.size == 0) {
            return Text('No Journals');
          }
          if (snapshot.hasData) {
            final journals =
                snapshot.data?.docs.map((e) => Journal.fromSnapshot(e));

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              physics: const BouncingScrollPhysics(),
              itemCount: journals?.length,
              itemBuilder: ((context, index) {
                final journal = journals?.elementAt(index);
                return JournalCard(journal!);
              }),
            );
          }
          //
          else {
            return const SizedBox.shrink();
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => goToPage(context, page: const JournalPage()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
