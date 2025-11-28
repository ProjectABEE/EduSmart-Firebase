import 'package:edusmart/providers/schedule_provider.dart';
import 'package:edusmart/widget/schedule.dart'; // Asumsi widget ini ada
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Diubah dari StatefulWidget menjadi StatelessWidget
class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  // Widget ini dipindahkan dan sekarang memanggil Provider
  Widget scheduleContainer(BuildContext context, String titleEnglish) {
    // Gunakan .read karena kita hanya memanggil fungsi (stream) dan tidak mendengarkan
    final provider = context.read<ScheduleProvider>();

    return StreamBuilder(
      // Panggil fungsi Stream dari Provider
      stream: provider.getSubjectsFor(titleEnglish),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 150,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Container(
            height: 150,
            alignment: Alignment.center,
            child: Text("Error loading schedule: ${snapshot.error}"),
          );
        }

        final docs = snapshot.data!.docs;

        return Container(
          padding: const EdgeInsets.only(left: 20),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          height:
              474, // PERHATIAN: Tinggi fixed (474) bisa menyebabkan error rendering jika konten terlalu banyak.
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              /// TITLE + COUNT
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 8, right: 24),
                child: Row(
                  children: [
                    // Ambil nama hari versi Indonesia dari Provider
                    Text(
                      provider.dayMapping[titleEnglish] ?? titleEnglish,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xffeaf0ff),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text("${docs.length} classes"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              /// DATA LIST
              Expanded(
                child: docs.isEmpty
                    ? const Center(child: Text("Tidak ada Jadwal Hari Ini"))
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: docs.length,
                        itemBuilder: (_, i) {
                          final d = docs[i].data() as Map<String, dynamic>;

                          final colors = [
                            Colors.purple,
                            Colors.blue,
                            Colors.orange,
                            Colors.green,
                            Colors.teal,
                            Colors.redAccent,
                            Colors.deepPurpleAccent,
                          ];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: ScheduleTile(
                              color: colors[i % colors.length],
                              subject: d["subject_name"],
                              teacher: d["teacher_name"],
                              room: d["room"],
                              time: "${d["start_time"]} - ${d["end_time"]}",
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              /// HEADER (Stateless)
              Container(
                height: 100,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0XFF2567E8),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      "Schedule",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// SECTION HEADER (Stateless)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Class Schedule", style: TextStyle(fontSize: 24)),
                        Text("Week Overview", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xffeaf0ff),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        color: Color(0xff3b82f6),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// LIST DAYS (Panggilan ke fungsi yang menggunakan Provider)
              scheduleContainer(context, "Monday"),
              scheduleContainer(context, "Tuesday"),
              scheduleContainer(context, "Wednesday"),
              scheduleContainer(context, "Thursday"),
              scheduleContainer(context, "Friday"),
              scheduleContainer(context, "Saturday"),
            ],
          ),
        ),
      ),
    );
  }
}
