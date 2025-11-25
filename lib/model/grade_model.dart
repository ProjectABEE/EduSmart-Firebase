class GradeModel {
  final int? id;
  final int studentId;
  final int subjectId;
  final String type;
  final double score;

  GradeModel({
    this.id,
    required this.studentId,
    required this.subjectId,
    required this.type,
    required this.score,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'student_id': studentId,
    'subject_id': subjectId,
    'type': type,
    'score': score,
  };

  factory GradeModel.fromMap(Map<String, dynamic> map) => GradeModel(
    id: map['id'],
    studentId: map['student_id'],
    subjectId: map['subject_id'],
    type: map['type'],
    score: map['score'],
  );
}
