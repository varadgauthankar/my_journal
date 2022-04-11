import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/pages/journal_page.dart';
import 'package:my_journal/utils/helpers.dart';
import 'package:my_journal/widgets/my_card.dart';

class JournalCard extends StatelessWidget {
  final Journal journal;
  const JournalCard(this.journal, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    String _getJournalDescription() {
      try {
        var json = jsonDecode(journal.description!);
        quill.QuillController _controller = quill.QuillController(
          document: quill.Document.fromJson(json),
          selection: const TextSelection.collapsed(offset: 0),
        );

        return _controller.document
            .getPlainText(0, _controller.document.length);
      } catch (_) {
        return journal.description ?? '';
      }
    }

    return MyCard(
      height: screenSize.height * .11,
      onTap: () => goToPage(context,
          page: JournalPage(
            journal: journal,
            isEdit: true,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            journal.title ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          spacer(height: 6.0),
          Text(
            _getJournalDescription(),
            maxLines: 2,
            overflow: TextOverflow.fade,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
