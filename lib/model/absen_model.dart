class AttendanceModel {
  final int? id;
  final int studentId; // ID siswa yang absen
  final String date; // misal format: yyyy-MM-dd
  final String? checkIn; // jam check in
  final String? checkOut; // jam check out
  final String status; // hadir, telat, absen

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
      'id': id,
      'studentId': studentId,
      'date': date,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'status': status,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id'],
      studentId: map['studentId'],
      date: map['date'],
      checkIn: map['checkIn'],
      checkOut: map['checkOut'],
      status: map['status'],
    );
  }
}
