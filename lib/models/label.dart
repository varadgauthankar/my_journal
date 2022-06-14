class Label {
  Label({this.label});

  String? label;

  Map<String, dynamic> toJson() => {'label': label};

  static Label fromJson(Map<String, dynamic> json) =>
      Label(label: json['label']);

  Label.fromSnapshot(snapshot) : label = snapshot.data()['label'];
}
