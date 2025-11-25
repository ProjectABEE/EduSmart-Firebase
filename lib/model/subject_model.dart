class SubjectModel {
  final String? id;
  final String name;

  SubjectModel({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {"name": name};
  }

  factory SubjectModel.fromMap(Map<String, dynamic> json) {
    return SubjectModel(id: json["id"], name: json["name"]);
  }
}
