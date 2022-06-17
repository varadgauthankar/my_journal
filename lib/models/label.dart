import 'package:equatable/equatable.dart';

class Label extends Equatable {
  const Label({this.label});

  final String? label;

  Map<String, dynamic> toJson() => {'label': label};

  static Label fromJson(Map<String, dynamic> json) =>
      Label(label: json['label']);

  Label.fromSnapshot(snapshot) : label = snapshot.data()['label'];

  @override
  List<Object?> get props => [label];
}
