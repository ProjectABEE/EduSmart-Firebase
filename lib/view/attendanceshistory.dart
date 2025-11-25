import 'package:edusmart/database/db_helper.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  final int studentId;
  const HistoryPage({super.key, required this.studentId});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> attendanceList = [];

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    final results = await DbHelper.getAttendanceByStudent(widget.studentId);
    setState(() {
      attendanceList = results;
    });
  }

  Future<void> _deleteAttendance(int id) async {
    await DbHelper.deleteAttendance(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Riwayat absensi berhasil dihapus")),
    );
    _loadAttendance(); // reload daftar setelah hapus
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Absensi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              // konfirmasi hapus semua data
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Hapus Semua Riwayat?"),
                  content: const Text(
                    "Apakah kamu yakin ingin menghapus semua riwayat absensi?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Batal"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Hapus Semua"),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await DbHelper.deleteAllAttendanceByStudent(widget.studentId);
                _loadAttendance();
              }
            },
          ),
        ],
      ),
      body: attendanceList.isEmpty
          ? const Center(child: Text("Belum ada riwayat absensi"))
          : ListView.builder(
              itemCount: attendanceList.length,
              itemBuilder: (context, index) {
                final item = attendanceList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(item['date']),
                    subtitle: Text(
                      "Masuk: ${item['check_in'] ?? '-'} | Pulang: ${item['check_out'] ?? '-'}",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _deleteAttendance(item['id']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
