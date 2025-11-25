class SubjectModel {
  final int? id;
  final String name;

  SubjectModel({this.id, required this.name});

  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  factory SubjectModel.fromMap(Map<String, dynamic> map) =>
      SubjectModel(id: map['id'], name: map['name']);
}
