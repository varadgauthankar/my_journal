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
  bool _isEdit = false;

  void setInitialJournalData(Journal? journal) {
    if (journal != null) {
      _titleController.text = journal.title ?? '';
      _descriptionController.text = journal.description ?? '';

      _isEdit = true;

      notifyListeners();
    }
  }

  Future<void> _createJournal() async {
    if (_descriptionController.text.isNotEmpty) {
      _setState(JournalProviderState.loading);
      try {
        await _firestoreService.create(
          Journal(
            title: _titleController.text.isEmpty
                ? DateFormatter.formatToAppStandard(DateTime.now().toString())
                : _titleController.text,
            description: _descriptionController.text,
            createdAt: DateTime.now().toString(),
            updatedAt: DateTime.now().toString(),
          ),
        );
        _setState(JournalProviderState.complete);
      } catch (e) {
        _setState(JournalProviderState.error);
      }
    }
  }

  Future<void> _updateJournal() async {
    try {
      final updatedJournal = _existingJournal!
        ..title = _titleController.text
        ..description = _descriptionController.text
        ..updatedAt = DateTime.now().toString();

      _firestoreService.update(updatedJournal);
    } catch (e) {}
  }

  void _disposeControllers() {
    _titleController.clear();
    _descriptionController.clear();
  }

  void handleSavingJournal(BuildContext context) async {
    if (_isEdit) {
      await _updateJournal();
    } else {
      await _createJournal();
    }
    _disposeControllers();
    Navigator.pop(context);
  }

  void _setState(JournalProviderState state) {
    _state = state;
    notifyListeners();
  }
}
