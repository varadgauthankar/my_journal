import 'package:flutter/material.dart';
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
            journal.description ?? '',
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
