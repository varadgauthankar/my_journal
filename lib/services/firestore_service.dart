import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/models/label.dart';

class FirestoreService {
  FirebaseFirestore? _firestore;
  CollectionReference? _journals;
  CollectionReference? _labels;
  FirebaseAuth? _auth;
  String? _uid;

  CollectionReference? get journals => _journals;
  CollectionReference? get labels => _labels;

  FirestoreService() {
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
    _uid = _auth?.currentUser?.uid;
    _journals = _firestore!.collection(_uid!);
    _labels =
        _firestore!.collection('users_settings').doc(_uid).collection('labels');
  }

  // labels

  Future<void> createLabel(Label label) async {
    final labelDoc = _labels?.doc();
    await labelDoc
        ?.set(label.toJson())
        .timeout(const Duration(seconds: 3), onTimeout: () {});
    // setting timeout so offline works
  }

  Future<void> deleteLabel(Label label) async {
    throw UnimplementedError('delete not implemented');
    final labelDoc = _labels?.doc('label.id');
    await labelDoc
        ?.delete()
        .timeout(const Duration(seconds: 3), onTimeout: () {});
    // setting timeout so offline works
  }

  Future<void> updateLabel(Label label) async {
    throw UnimplementedError('update not implemented');
    final labelDoc = _labels?.doc('label.id');
    await labelDoc
        ?.update(label.toJson())
        .timeout(const Duration(seconds: 3), onTimeout: () {});
    // setting timeout so offline works
  }

  // Journal stuff below

  Future<void> create(Journal journal) async {
    final journalDoc = _journals!.doc();
    final journalWithId = journal..id = journalDoc.id;

    await journalDoc
        .set(Journal.encrypt(journalWithId).toJson())
        .timeout(const Duration(seconds: 3), onTimeout: () {});

    // setting the timeout so the offline storage of firestore works
    // https://stackoverflow.com/questions/53549773/using-offline-persistence-in-firestore-in-a-flutter-app
  }

  Future<void> update(Journal journal) async {
    final journalDoc = _journals!.doc(journal.id);
    await journalDoc
        .update(Journal.encrypt(journal).toJson())
        .timeout(const Duration(seconds: 3), onTimeout: () {});

    // setting the timeout so the offline storage of firestore works
    // https://stackoverflow.com/questions/53549773/using-offline-persistence-in-firestore-in-a-flutter-app
  }

  Future<void> delete(Journal journal) async {
    final journalDoc = _journals!.doc(journal.id);
    await journalDoc.delete();
  }
}
