import 'package:equatable/equatable.dart';

class Label extends Equatable {
  String? label;
  String? id;
  String? createdAt;

  Label({this.id, this.label, this.createdAt});

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'createdAt': createdAt,
      };

  static Label fromJson(Map<String, dynamic> json) => Label(
        id: json['id'],
        label: json['label'],
        createdAt: json['createdAt'],
      );

  Label.fromSnapshot(snapshot)
      : id = snapshot.data()['id'],
        label = snapshot.data()['label'],
        createdAt = snapshot.data()['createdAt'];

  @override
  List<Object?> get props => [label];
}
