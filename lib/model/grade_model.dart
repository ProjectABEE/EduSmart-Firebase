class GradeModel {
  final String? id;
  final String studentId;
  final String subjectId;
  final String type;
  final double score;

  GradeModel({
    this.id,
    required this.studentId,
    required this.subjectId,
    required this.type,
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return {
      "student_id": studentId,
      "subject_id": subjectId,
      "type": type,
      "score": score,
    };
  }

  factory GradeModel.fromMap(Map<String, dynamic> json) {
    return GradeModel(
      id: json["id"],
      studentId: json["student_id"],
      subjectId: json["subject_id"],
      type: json["type"],
      score: (json["score"] as num).toDouble(),
    );
  }
}
