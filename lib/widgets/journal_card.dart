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
    String getJournalDescription(String jsonString) {
      try {
        var json = jsonDecode(jsonString);
        quill.QuillController controller = quill.QuillController(
          document: quill.Document.fromJson(json),
          selection: const TextSelection.collapsed(offset: 0),
        );

        return controller.document.getPlainText(0, controller.document.length);
      } catch (_) {
        return journal.description ?? '';
      }
    }

    return MyCard(
        onTap: () => goToPage(
              context,
              page: JournalPage(
                journal: journal,
                isEdit: true,
              ),
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              journal.title ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: getColorScheme(context).onSurface,
                  ),
            ),
            Text(
              getJournalDescription(journal.description ?? ''),
              maxLines: 2,
              overflow: TextOverflow.fade,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: getColorScheme(context).onSurfaceVariant,
                  ),
            ),
          ],
        ));
  }
}
