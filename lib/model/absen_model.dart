class AttendanceModel {
  final String? id;
  final String studentId;
  final String date;
  final String? checkIn;
  final String? checkOut;
  final String status;

  AttendanceModel({
    this.id,
    required this.studentId,
    required this.date,
    this.checkIn,
    this.checkOut,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      "student_id": studentId,
      "date": date,
      "check_in": checkIn,
      "check_out": checkOut,
      "status": status,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json["id"],
      studentId: json["student_id"],
      date: json["date"],
      checkIn: json["check_in"],
      checkOut: json["check_out"],
      status: json["status"] ?? "Hadir",
    );
  }
}
