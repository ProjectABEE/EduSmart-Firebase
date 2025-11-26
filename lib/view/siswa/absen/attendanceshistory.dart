import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  final String studentId; // now Firebase UID, not int
  const HistoryPage({super.key, required this.studentId});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> attendanceList = [];

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    final snap = await firestore
        .collection("attendance")
        .where("student_id", isEqualTo: widget.studentId)
        .orderBy("date", descending: true)
        .get();

    setState(() {
      attendanceList = snap.docs.map((e) => {"id": e.id, ...e.data()}).toList();
    });
  }

  Future<void> _deleteAttendance(String id) async {
    await firestore.collection("attendance").doc(id).delete();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Riwayat absensi berhasil dihapus")));
    _loadAttendance();
  }

  Future<void> _deleteAllAttendance() async {
    final batch = firestore.batch();

    final snap = await firestore
        .collection("attendance")
        .where("student_id", isEqualTo: widget.studentId)
        .get();

    for (var doc in snap.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Semua riwayat berhasil dihapus")));

    _loadAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Riwayat Absensi"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Hapus Semua Riwayat?"),
                  content: Text(
                    "Apakah kamu yakin ingin menghapus semua data?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text("Batal"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text("Hapus Semua"),
                    ),
                  ],
                ),
              );

              if (confirm == true) _deleteAllAttendance();
            },
          ),
        ],
      ),

      body: attendanceList.isEmpty
          ? Center(child: Text("Belum ada riwayat absensi"))
          : ListView.builder(
              itemCount: attendanceList.length,
              itemBuilder: (context, index) {
                final item = attendanceList[index];

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(item['date']),
                    subtitle: Text(
                      "Masuk: ${item['check_in'] ?? '-'} | Pulang: ${item['check_out'] ?? '-'}",
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _deleteAttendance(item['id']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
