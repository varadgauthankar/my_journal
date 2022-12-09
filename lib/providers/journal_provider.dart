import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/models/label.dart';
import 'package:my_journal/services/firestore_service.dart';
import 'package:my_journal/utils/date_formatter.dart';

enum JournalProviderState { initial, loading, complete, error }

class JournalProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final _titleController = TextEditingController();

  var _quillController = QuillController.basic();
  QuillController get quillController => _quillController;

  JournalProviderState _state = JournalProviderState.initial;
  JournalProviderState get state => _state;

  TextEditingController get titleController => _titleController;

  Journal? _existingJournal;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Label> _journalLabels = [];
  List<Label> get journalLabels => _journalLabels;

  void setJournalLabels(List<Label>? labels) {
    // _journalLabels.clear();
    _journalLabels = labels ?? [];
    notifyListeners();
  }

  bool _isChangesMade() {
    final encodedText =
        jsonEncode(_quillController.document.toDelta().toJson());

    if (_existingJournal?.title != _titleController.text ||
        _existingJournal?.description != encodedText ||
        !listEquals(_existingJournal?.labels, _journalLabels)) {
      return true;
    } else {
      return false;
    }
  }

  void setInitialJournalData(Journal? journal) {
    if (journal != null) {
      _titleController.text = journal.title ?? 'meow';
      _journalLabels = journal.labels ?? [];
      try {
        var myJson = jsonDecode(journal.description!);
        _quillController = QuillController(
          document: Document.fromJson(myJson),
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        _quillController = QuillController(
          document: Document.fromJson([
            {'insert': (journal.description! + '\n')},
          ]),
          selection: const TextSelection.collapsed(offset: 0),
        );
      }

      _existingJournal = journal;
      notifyListeners();
    }
  }

  Future<void> _createJournal() async {
    if (_quillController.document.length > 1) {
      _setState(JournalProviderState.loading);
      try {
        final encodedText =
            jsonEncode(_quillController.document.toDelta().toJson());

        final journalToCreate = Journal(
          title: _titleController.text.isEmpty
              ? DateFormatter.formatToAppStandard(DateTime.now().toString())
              : _titleController.text,
          description: encodedText,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
          labels: _journalLabels,
        );
        await _firestoreService.create(journalToCreate);
        _setState(JournalProviderState.complete);
      } catch (e) {
        _errorMessage = e.toString();
        _setState(JournalProviderState.error);
        // ignore: avoid_print
        print('CREATE EXCEPTION : $e');
      }
    }
  }

  Future<void> _updateJournal() async {
    if (_quillController.document.length > 1) {
      _setState(JournalProviderState.loading);
      try {
        final encodedText =
            jsonEncode(_quillController.document.toDelta().toJson());

        final updatedJournal = _existingJournal!
          ..title = _titleController.text
          ..description = encodedText
          ..labels = _journalLabels
          ..updatedAt = DateTime.now().toString();

        await _firestoreService.update(updatedJournal);
        _setState(JournalProviderState.complete);
      } catch (e) {
        _errorMessage = e.toString();
        _setState(JournalProviderState.error);
        // ignore: avoid_print
        print('UPDATE EXCEPTION : $e');
      }
    }
  }

  Future<void> deleteJournal() async {
    try {
      _setState(JournalProviderState.loading);
      _firestoreService.delete(_existingJournal!); // cant be null on edit state
      _clearControllers();
      _setState(JournalProviderState.complete);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(JournalProviderState.error);
      // ignore: avoid_print
      print('DELETE EXCEPTION : $e');
    }
  }

  String _getDefaultJournalTitle() {
    final String _todaysDate = DateTime.now().toString();
    return DateFormatter.formatToAppStandard(_todaysDate);
  }

  void _clearControllers() {
    _titleController.clear();
    _quillController.clear();
    _journalLabels.clear();
  }

  void handleSavingJournal(BuildContext context, {required bool isEdit}) async {
    if (isEdit) {
      if (_isChangesMade()) {
        await _updateJournal();
      }
    } else {
      await _createJournal();
    }

    if (_state != JournalProviderState.error) {
      _clearControllers();
      _disposeState();
      Navigator.pop(context);
    }
  }

  void _setState(JournalProviderState state) {
    _state = state;
    notifyListeners();
  }

  void _disposeState() {
    _state = JournalProviderState.initial;
  }
}
