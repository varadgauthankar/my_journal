import 'package:flutter/material.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/utils/date_formatter.dart';

class JournalPage extends StatefulWidget {
  final Journal journal;
  const JournalPage(this.journal, {Key? key}) : super(key: key);

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  String _getDefaultTitle() {
    final String _todaysDate = DateTime.now().toString();
    return DateFormatter.formatToAppStandard(_todaysDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(12.0),
        children: [
          TextFormField(
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: _getDefaultTitle(),
              border: InputBorder.none,
            ),
          ),
          TextFormField(
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
    );
  }
}
