class Journal {
  String? title;
  String? description;
  String? dateCreated;
  String? dateUpdated;

  Journal({this.title, this.description, this.dateCreated, this.dateUpdated});

  @override
  String toString() {
    return 'Title: $title\nDescription: $description\nDateCreated: $dateCreated\nDateUpdated: $dateUpdated';
  }
}
