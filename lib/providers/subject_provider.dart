import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edusmart/services/firebase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubjectProvider extends ChangeNotifier {
  // ==================== STATE (yang sebelumnya di _AdminSubjectsPageState) ====================

  // State Input Form
  final TextEditingController subjectController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _selectedRoom;
  String? _selectedTeacher;
  String? _selectedDay;
  bool _isLoading = false;

  // Data Pilihan
  final List<String> rooms = [
    "Ruang 101",
    "Ruang 102",
    "Ruang 201",
    "Ruang 202",
    "Lab 1",
    "Lab 2",
    "Aula",
  ];
  final List<String> teachers = [
    "Pak Budi",
    "Bu Amelia",
    "Pak Rudi",
    "Bu Sinta",
    "Pak Fajar",
    "Bu Maya",
    "Pak Gunawan",
  ];
  final List<String> days = [
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jumat",
    "Sabtu",
  ];

  // ==================== GETTER UNTUK MENGAKSES STATE ====================

  TimeOfDay? get startTime => _startTime;
  TimeOfDay? get endTime => _endTime;
  String? get selectedRoom => _selectedRoom;
  String? get selectedTeacher => _selectedTeacher;
  String? get selectedDay => _selectedDay;
  bool get isLoading => _isLoading;

  // ==================== SETTER UNTUK MENGUBAH STATE ====================

  set selectedRoom(String? val) {
    _selectedRoom = val;
    notifyListeners();
  }

  set selectedTeacher(String? val) {
    _selectedTeacher = val;
    notifyListeners();
  }

  set selectedDay(String? val) {
    _selectedDay = val;
    notifyListeners();
  }

  void setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  // ==================== FUNGSI LOGIKA ====================

  String formatTime(TimeOfDay t) {
    final dt = DateTime(2025, 1, 1, t.hour, t.minute);
    return DateFormat("HH:mm").format(dt);
  }

  TimeOfDay toTimeOfDay(String time) {
    final parts = time.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  // Fungsi untuk menampilkan time picker (membutuhkan context)
  Future<void> pickStartTime(BuildContext context) async {
    final t = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay(hour: 7, minute: 0),
    );
    if (t != null) {
      _startTime = t;
      notifyListeners(); // Beri tahu UI untuk update tombol
    }
  }

  Future<void> pickEndTime(BuildContext context) async {
    final t = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay(hour: 9, minute: 0),
    );
    if (t != null) {
      _endTime = t;
      notifyListeners(); // Beri tahu UI untuk update tombol
    }
  }

  void clearForm() {
    subjectController.clear();
    _selectedTeacher = null;
    _selectedRoom = null;
    _selectedDay = null;
    _startTime = null;
    _endTime = null;
    notifyListeners();
  }

  // Fungsi untuk mengisi form saat edit
  void setFormForEdit(Map data) {
    subjectController.text = data["subject_name"];
    _selectedRoom = data["room"];
    _selectedTeacher = data["teacher_name"];
    _selectedDay = data["day"];
    _startTime = toTimeOfDay(data["start_time"]);
    _endTime = toTimeOfDay(data["end_time"]);
  }

  // ==================== FUNGSI CRUD FIREBASE (Memanggil FirebaseServices) ====================

  // Menggantikan fungsi addSubject() lama
  Future<void> addSubject(BuildContext context) async {
    if (subjectController.text.isEmpty ||
        _startTime == null ||
        _endTime == null ||
        _selectedRoom == null ||
        _selectedTeacher == null ||
        _selectedDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Isi semua input dulu ya 🔥")),
      );
      return;
    }

    setLoading(true);

    final subjectData = {
      "subject_name": subjectController.text.trim(),
      "start_time": formatTime(_startTime!),
      "end_time": formatTime(_endTime!),
      "teacher_name": _selectedTeacher,
      "room": _selectedRoom,
      "day": _selectedDay,
      "createdAt": DateTime.now().toString(),
    };

    // Panggil fungsi yang sudah ada di FirebaseServices
    await FirebaseServices.insertSubject(subjectData);

    clearForm();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Mata pelajaran ditambahkan 🎉")),
    );

    setLoading(false);
  }

  // Menggantikan fungsi editSubject(String id) lama
  Future<void> editSubject(BuildContext context, String id) async {
    if (_startTime == null || _endTime == null) {
      // Tambahkan validasi jika diperlukan
      return;
    }

    final subjectData = {
      "subject_name": subjectController.text.trim(),
      "start_time": formatTime(_startTime!),
      "end_time": formatTime(_endTime!),
      "teacher_name": _selectedTeacher,
      "room": _selectedRoom,
      "day": _selectedDay,
    };

    // Panggil fungsi yang sudah ada di FirebaseServices
    await FirebaseServices.updateSubject(id, subjectData);

    // clearForm(); // Tidak perlu clear jika setelah ini dialog ditutup

    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Data berhasil diperbarui ✔")));
  }

  // Fungsi Stream untuk List Mata Pelajaran
  Stream<QuerySnapshot<Map<String, dynamic>>> get subjectsStream {
    return FirebaseServices.firestore
        .collection(FirebaseServices.subjectsCollection)
        .orderBy("day")
        .snapshots();
  }
}
