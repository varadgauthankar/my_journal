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

  void disposeControllers() {
    _titleController.clear();
    _descriptionController.clear();
  }

  Future<void> createJournal() async {
    if (_descriptionController.text.isNotEmpty) {
      setState(JournalProviderState.loading);
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

        setState(JournalProviderState.complete);
      } catch (e) {
        setState(JournalProviderState.error);
      }
    }
  }

  void setState(JournalProviderState state) {
    _state = state;
    notifyListeners();
  }
}
