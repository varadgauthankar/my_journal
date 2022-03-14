import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/pages/journal_page.dart';
import 'package:my_journal/pages/settings_page.dart';
import 'package:my_journal/services/firestore_service.dart';
import 'package:my_journal/utils/color_schemes.dart';
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService!.journals!
            .orderBy('updatedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _exceptionWidget(isError: true);
          }
          if (snapshot.data?.size == 0) {
            return _exceptionWidget();
          }
          if (snapshot.hasData) {
            final journals =
                snapshot.data?.docs.map((e) => Journal.fromSnapshot(e));

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

  Widget _exceptionWidget({bool isError = false}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isError
              ? const Icon(
                  EvaIcons.alertTriangleOutline,
                  size: 80,
                  color: Colors.amberAccent,
                )
              : SvgPicture.asset(
                  'assets/empty.svg',
                  height: 120,
                ),
          spacer(height: 12),
          Text(
            isError ? 'Something went wrong!' : 'No Journals yet!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: isError ? FontWeight.w500 : FontWeight.bold,
              color: false ? darkColorScheme.primary : lightColorScheme.primary,
            ),
          )
        ],
      ),
    );
  }
}
