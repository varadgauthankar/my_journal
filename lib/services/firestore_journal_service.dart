import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/models/label.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreJournalService {
  FirebaseFirestore? _firestore;
  CollectionReference? _journals;
  CollectionReference? _labels;
  FirebaseAuth? _auth;
  String? _uid;

  CollectionReference? get journals => _journals;
  CollectionReference? get labels => _labels;

  FirestoreJournalService() {
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
    _uid = _auth?.currentUser?.uid;
    _journals =
        _firestore?.collection('users').doc(_uid).collection('journals');
    _labels = _firestore?.collection('users').doc(_uid).collection('labels');
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
    final allLabels = await _labels?.get();

    for (final doc in allLabels!.docs) {
      if (label.label == Label.fromSnapshot(doc).label) {
        _labels?.doc(doc.id).delete();
      }
    }
  }

  Future<void> updateLabel(Label label) async {
    throw UnimplementedError('update not implemented');
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

  // this method only runs once,
  // only used to structure the firestore database
  // I am stupid lol
  void moveFireStoreCollection() async {
    final prefs = await SharedPreferences.getInstance();

    final firestoreMovingDone = prefs.getBool('firestoreMovingDone') ?? false;

    if (!firestoreMovingDone) {
      final newJournalColl =
          _firestore?.collection('users').doc(_uid).collection('journals');

      final oldJournalColl = _firestore?.collection(_uid!);

      final oldLabelsColl = _firestore!
          .collection('users_settings')
          .doc(_uid)
          .collection('labels');

      final newLabelsColl =
          _firestore?.collection('users').doc(_uid).collection('labels');

      final allExistingJournals = await oldJournalColl?.get();
      final allExistingLabels = await oldLabelsColl.get();

      final batch = FirebaseFirestore.instance.batch();

      if (allExistingJournals!.docs.isNotEmpty) {
        for (final journalSnapshot in allExistingJournals.docs) {
          Journal journal = Journal.fromSnapshot(journalSnapshot);
          batch.set(newJournalColl!.doc(journal.id), journal.toJson());
          batch.delete(journalSnapshot.reference);
        }
      }

      if (allExistingLabels.docs.isNotEmpty) {
        for (final labelSnapshot in allExistingLabels.docs) {
          Label label = Label.fromSnapshot(labelSnapshot);
          batch.set(newLabelsColl!.doc(), label.toJson());
          batch.delete(labelSnapshot.reference);
        }
      }

      batch.commit();

      prefs.setBool('firestoreMovingDone', true);
    }
  }
}
