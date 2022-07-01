import 'package:equatable/equatable.dart';

class Label extends Equatable {
  String? label;
  String? id;

  Label({this.id, this.label});

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
      };

  static Label fromJson(Map<String, dynamic> json) => Label(
        id: json['id'],
        label: json['label'],
      );

  Label.fromSnapshot(snapshot)
      : id = snapshot.data()['id'],
        label = snapshot.data()['label'];

  @override
  List<Object?> get props => [label];
}
