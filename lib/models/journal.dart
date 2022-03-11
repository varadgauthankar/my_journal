class Journal {
  String? id;
  String? title;
  String? description;
  String? createdAt;
  String? updatedAt;

  Journal({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  static Journal fromJson(Map<String, dynamic> json) => Journal(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );

  Journal.fromSnapshot(snapshot)
      : id = snapshot.data()['id'],
        title = snapshot.data()['title'],
        description = snapshot.data()['description'],
        createdAt = snapshot.data()['createdAt'],
        updatedAt = snapshot.data()['updatedAt'];

  @override
  String toString() {
    return 'Title: $title\nDescription: $description\nCreatedAt: $createdAt\nUpdatedAt: $updatedAt';
  }
}
