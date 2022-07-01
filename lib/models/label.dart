import 'package:equatable/equatable.dart';

class Label extends Equatable {
  String? label;

  Label({this.label});

  Map<String, dynamic> toJson() => {
        'label': label,
      };

  static Label fromJson(Map<String, dynamic> json) => Label(
        label: json['label'],
      );

  Label.fromSnapshot(snapshot) : label = snapshot.data()['label'];

  @override
  List<Object?> get props => [label];
}
