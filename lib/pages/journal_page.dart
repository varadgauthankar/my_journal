import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/providers/journal_provider.dart';
import 'package:my_journal/utils/date_formatter.dart';
import 'package:provider/provider.dart';

class JournalPage extends StatefulWidget {
  final Journal? journal;
  const JournalPage({Key? key, this.journal}) : super(key: key);

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  String _getDefaultJournalTitle() {
    final String _todaysDate = DateTime.now().toString();
    return DateFormatter.formatToAppStandard(_todaysDate);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JournalProvider>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              value.createJournal();
              value.disposeControllers();
              Navigator.pop(context);
            },
            icon: const Icon(EvaIcons.chevronLeft),
          ),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          children: [
            TextFormField(
              controller: value.titleController,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: _getDefaultJournalTitle(),
                border: InputBorder.none,
              ),
            ),
            TextFormField(
              controller: value.descriptionController,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
              decoration: const InputDecoration(
                hintText: 'How was your day?',
                border: InputBorder.none,
              ),
              maxLines: null,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await value.createJournal();
            value.disposeControllers();
            if (value.state == JournalProviderState.complete) {
              Navigator.pop(context);
            }
          },
          child: const Icon(EvaIcons.checkmark),
        ),
      );
    });
  }
}
