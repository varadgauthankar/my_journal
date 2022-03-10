import 'package:flutter/material.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/widgets/journal_card.dart';
import 'package:my_journal/widgets/my_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        physics: const BouncingScrollPhysics(),
        itemCount: 12,
        itemBuilder: ((context, index) {
          var journal = Journal(
            title: 'Tue, 25 Aug',
            description:
                'Lorem ipsum dolor Enim dolor est laborum aliqua. Velit consequat occaecat aliqua anim consequat ea esse. Proident enim eiusmod fugiat sint magna labore fugiat voluptate deserunt ad quis eiusmod commodo occaecat. Ad voluptate ex excepteur dolor aliquip esse ea sunt.',
          );
          return JournalCard(journal);
        }),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
