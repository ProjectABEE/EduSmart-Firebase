import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edusmart/providers/subject_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminSubjectsPage extends StatelessWidget {
  const AdminSubjectsPage({super.key});

  // Warna Primer Konsisten
  static const Color primaryColor = Color(0xFF256BE8);

  void showEditDialog(BuildContext context, Map data, String id) {
    final provider = context.read<SubjectProvider>();

    // Set form field controller dan selected value
    provider.subjectController.text = data['subject_name'] ?? '';
    provider.selectedDay = data['day'];
    provider.selectedTeacher = data['teacher_name'];
    provider.selectedRoom = data['room'];
    // Logic untuk setting TimeOfDay harus dilakukan di provider,
    // namun kita hanya memastikan controller/dropdown diset

    // Jika provider.setFormForEdit ada, gunakan itu:
    provider.setFormForEdit(data);

    showDialog(
      context: context,
      builder: (_) {
        return Consumer<SubjectProvider>(
          builder: (context, model, child) {
            return AlertDialog(
              title: const Text("Edit Mata Pelajaran"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Agar konten menyesuaikan
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Nama Mapel",
                        border: OutlineInputBorder(),
                      ),
                      controller: model.subjectController,
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      initialValue: model.selectedDay,
                      decoration: const InputDecoration(
                        labelText: "Hari",
                        border: OutlineInputBorder(),
                      ),
                      items: model.days
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => model.selectedDay = v,
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      initialValue: model.selectedTeacher,
                      decoration: const InputDecoration(
                        labelText: "Guru Pengajar",
                        border: OutlineInputBorder(),
                      ),
                      items: model.teachers
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => model.selectedTeacher = v,
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      initialValue: model.selectedRoom,
                      decoration: const InputDecoration(
                        labelText: "Ruangan",
                        border: OutlineInputBorder(),
                      ),
                      items: model.rooms
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => model.selectedRoom = v,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade100,
                              foregroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => model.pickStartTime(context),
                            child: Text(
                              "Mulai: ${model.startTime != null ? model.formatTime(model.startTime!) : 'Pilih Jam'}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade100,
                              foregroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => model.pickEndTime(context),
                            child: Text(
                              "Selesai: ${model.endTime != null ? model.formatTime(model.endTime!) : 'Pilih Jam'}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "BATAL",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => model.editSubject(context, id),
                  child: const Text("SIMPAN"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubjectProvider>();
    final providerRead = context.read<SubjectProvider>();

    return Scaffold(
      // Menggunakan Column dan SingleChildScrollView untuk menggabungkan header dan konten scrollable
      body: Column(
        children: [
          // Header Kustom
          Container(
            height: 100,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Kelola Mata Pelajaran",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // --- Form Input (Scrollable) ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Form Tambah Mata Pelajaran",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: provider.subjectController,
                    decoration: const InputDecoration(
                      labelText: "Nama Mata Pelajaran",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Pilih Hari",
                      border: OutlineInputBorder(),
                    ),
                    initialValue: provider.selectedDay,
                    items: provider.days
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => provider.selectedDay = val,
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Pilih Guru",
                      border: OutlineInputBorder(),
                    ),
                    initialValue: provider.selectedTeacher,
                    items: provider.teachers
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => provider.selectedTeacher = val,
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Pilih Ruangan",
                      border: OutlineInputBorder(),
                    ),
                    initialValue: provider.selectedRoom,
                    items: provider.rooms
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => provider.selectedRoom = val,
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade100,
                            foregroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(12),
                          ),
                          onPressed: () => providerRead.pickStartTime(context),
                          child: Text(
                            provider.startTime == null
                                ? "Jam Mulai"
                                : "Mulai: ${provider.formatTime(provider.startTime!)}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade100,
                            foregroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(12),
                          ),
                          onPressed: () => providerRead.pickEndTime(context),
                          child: Text(
                            provider.endTime == null
                                ? "Jam Selesai"
                                : "Selesai: ${provider.formatTime(provider.endTime!)}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: provider.isLoading
                          ? null
                          : () => providerRead.addSubject(context),
                      child: provider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Tambah Mata Pelajaran",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(height: 1, thickness: 1),
                  const SizedBox(height: 10),

                  // --- List Data Header ---
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Daftar Mata Pelajaran Terdaftar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // --- List Data ---
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: provider.subjectsStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final data = snapshot.data!.docs;

                      if (data.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Text(
                              "Belum ada data mata pelajaran. Silakan tambahkan di atas.",
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(), // Di dalam SingleChildScrollView
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final mapel = data[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.book_outlined,
                                  color: primaryColor,
                                ),
                              ),
                              title: Text(
                                mapel["subject_name"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  // Baris Hari dan Jam
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.schedule,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${mapel["day"]} • ${mapel["start_time"]} - ${mapel["end_time"]}",
                                        style: const TextStyle(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Baris Guru dan Ruangan
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.person_outline,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        mapel["teacher_name"],
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.meeting_room_outlined,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        mapel["room"],
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: const Icon(
                                Icons.edit,
                                color: primaryColor,
                                size: 20,
                              ),
                              isThreeLine: true,
                              onTap: () => showEditDialog(
                                context,
                                mapel.data(),
                                mapel.id,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
