import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edusmart/providers/subject_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'firebase.dart'; // Tidak perlu import firebase di widget ini lagi

class AdminSubjectsPage extends StatelessWidget {
  const AdminSubjectsPage({super.key});

  /// ================== EDIT DIALOG (Dipindahkan dari State) ===================
  void showEditDialog(BuildContext context, Map data, String id) {
    // 1. Ambil Provider dengan .read untuk MENGUBAH state (setFormForEdit)
    final provider = context.read<SubjectProvider>();
    provider.setFormForEdit(data);

    showDialog(
      context: context,
      builder: (_) {
        // 2. Gunakan Consumer/context.watch di sini untuk mendengarkan perubahan TimePicker
        return Consumer<SubjectProvider>(
          builder: (context, model, child) {
            return AlertDialog(
              title: const Text("Edit Mata Pelajaran"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Nama Mapel",
                      ),
                      controller: model.subjectController,
                    ),
                    const SizedBox(height: 10),
                    // Dropdown membutuhkan setter di provider
                    DropdownButtonFormField<String>(
                      initialValue: model.selectedDay, // Gunakan getter
                      items: model.days
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => model.selectedDay = v, // Gunakan setter
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: model.selectedTeacher,
                      items: model.teachers
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => model.selectedTeacher = v,
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: model.selectedRoom,
                      items: model.rooms
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => model.selectedRoom = v,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            // Panggil fungsi provider dengan context
                            onPressed: () => model.pickStartTime(context),
                            child: Text(
                              "Mulai: ${model.formatTime(model.startTime!)}",
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            // Panggil fungsi provider dengan context
                            onPressed: () => model.pickEndTime(context),
                            child: Text(
                              "Selesai: ${model.formatTime(model.endTime!)}",
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
                  child: const Text("BATAL"),
                ),
                ElevatedButton(
                  // Panggil fungsi provider dengan context dan id
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

  /// ================= UI ==================
  @override
  Widget build(BuildContext context) {
    // 3. Ambil provider dengan .watch untuk mendengarkan perubahan (rebuild UI)
    final provider = context.watch<SubjectProvider>();
    // 4. Ambil provider dengan .read untuk memanggil fungsi (tanpa rebuild UI)
    final providerRead = context.read<SubjectProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Mata Pelajaran — Admin")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Semua input sekarang menggunakan controller/state dari provider
            TextField(
              controller: provider.subjectController,
              decoration: const InputDecoration(
                labelText: "Nama Mata Pelajaran",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Dropdown menggunakan setter di provider
            DropdownButtonFormField<String>(
              hint: const Text("Pilih Hari"),
              initialValue: provider.selectedDay,
              items: provider.days
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => provider.selectedDay = val,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              hint: const Text("Pilih Guru"),
              initialValue: provider.selectedTeacher,
              items: provider.teachers
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => provider.selectedTeacher = val,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              hint: const Text("Pilih Ruangan"),
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
                    // Panggil fungsi provider dengan context
                    onPressed: () => providerRead.pickStartTime(context),
                    child: Text(
                      provider.startTime == null
                          ? "Jam Mulai"
                          : "Mulai: ${provider.formatTime(provider.startTime!)}",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    // Panggil fungsi provider dengan context
                    onPressed: () => providerRead.pickEndTime(context),
                    child: Text(
                      provider.endTime == null
                          ? "Jam Selesai"
                          : "Selesai: ${provider.formatTime(provider.endTime!)}",
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // Menggunakan .read untuk memanggil fungsi (tanpa rebuild)
                onPressed: provider.isLoading
                    ? null
                    : () => providerRead.addSubject(context),
                child: provider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Tambah Mata Pelajaran"),
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),

            // StreamBuilder tetap di sini, tetapi menggunakan Stream dari provider
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: provider.subjectsStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.data!.docs;

                  if (data.isEmpty) {
                    return const Center(child: Text("Belum ada data mapel ✔"));
                  }

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final mapel = data[index];
                      return Card(
                        child: ListTile(
                          title: Text(mapel["subject_name"]),
                          subtitle: Text(
                            "${mapel["day"]} • ${mapel["start_time"]} - ${mapel["end_time"]}\n${mapel["teacher_name"]} | ${mapel["room"]}",
                          ),
                          // Panggil fungsi dialog di widget ini
                          onTap: () =>
                              showEditDialog(context, mapel.data(), mapel.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
