import 'package:my_journal/models/label.dart';
import 'package:my_journal/services/encryption_service.dart';

class Journal {
  String? id;
  String? title;
  String? description;
  String? createdAt;
  String? updatedAt;
  List<Label>? labels;

  Journal({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.labels,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'labels': labels?.map((e) => e.toJson()).toList(),
      };

  Journal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    labels = <Label>[];

    if (json['labels'] != null) {
      labels = json['labels']?.map((e) => Label.fromJson(e))?.toList();
    }
  }

  Journal.fromSnapshot(snapshot) {
    id = snapshot.data()['id'];
    title = snapshot.data()['title'];
    description = snapshot.data()['description'];
    createdAt = snapshot.data()['createdAt'];
    updatedAt = snapshot.data()['updatedAt'];
    labels = <Label>[];

    if (snapshot.data()['labels'] != null) {
      snapshot.data()['labels']?.forEach((e) => labels?.add(Label.fromJson(e)));
    }
  }

  static Journal encrypt(Journal journal) {
    EncryptionService _encryptionService = EncryptionService();
    return journal
      ..title = _encryptionService.encrypt(journal.title!)
      ..description = _encryptionService.encrypt(journal.description!);
  }

  static Journal decrypt(Journal journal) {
    EncryptionService _encryptionService = EncryptionService();
    return journal
      ..title = _encryptionService.decrypt(journal.title!)
      ..description = _encryptionService.decrypt(journal.description!);
  }

  @override
  String toString() {
    return 'Title: $title\nDescription: $description\nCreatedAt: $createdAt\nUpdatedAt: $updatedAt';
  }
}
