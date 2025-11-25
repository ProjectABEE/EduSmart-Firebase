import 'package:flutter/material.dart';

class DayScheduleWidget extends StatelessWidget {
  final String day;
  final List<Map<String, String>> subjects;

  const DayScheduleWidget({
    super.key,
    required this.day,
    required this.subjects,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Hari
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    day,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "${subjects.length} lessons",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // List Pelajaran
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final lesson = subjects[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 6,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.primaries[
                              index % Colors.primaries.length],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      title: Text(
                        lesson["subject"]!,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(lesson["teacher"]!),
                      trailing: Text(
                        lesson["time"]!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}