import 'package:flutter/material.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/services/firestore_service.dart';
import 'package:my_journal/utils/date_formatter.dart';

enum JournalProviderState { initial, loading, complete, error }

class JournalProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  JournalProviderState _state = JournalProviderState.initial;
  JournalProviderState get state => _state;

  TextEditingController get titleController => _titleController;
  TextEditingController get descriptionController => _descriptionController;

  Journal? _existingJournal;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isChangesMade() {
    if (_existingJournal?.title != _titleController.text ||
        _existingJournal?.description != _descriptionController.text) {
      return true;
    } else {
      return false;
    }
  }

  void setInitialJournalData(Journal? journal) {
    if (journal != null) {
      _titleController.text = journal.title ?? '';
      _descriptionController.text = journal.description ?? '';
      _existingJournal = journal;
      notifyListeners();
    }
  }

  Future<void> _createJournal() async {
    if (_descriptionController.text.isNotEmpty) {
      _setState(JournalProviderState.loading);
      try {
        final journalToCreate = Journal(
          title: _titleController.text.isEmpty
              ? DateFormatter.formatToAppStandard(DateTime.now().toString())
              : _titleController.text,
          description: _descriptionController.text,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
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
    if (_descriptionController.text.isNotEmpty) {
      _setState(JournalProviderState.loading);
      try {
        final updatedJournal = _existingJournal!
          ..title = _titleController.text
          ..description = _descriptionController.text
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

  void _clearControllers() {
    _titleController.clear();
    _descriptionController.clear();
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
