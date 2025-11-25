import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../model/grade_model.dart';
import '../model/subject_model.dart';

class AddGradePage extends StatefulWidget {
  const AddGradePage({super.key});

  @override
  State<AddGradePage> createState() => _AddGradePageState();
}

class _AddGradePageState extends State<AddGradePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();

  List<SubjectModel> subjects = [];
  SubjectModel? selectedSubject;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    final data = await DbHelper.getAllSubjects();
    setState(() {
      subjects = data.map((e) => SubjectModel.fromMap(e)).toList();
    });
  }

  Future<void> _addGrade() async {
    if (_formKey.currentState!.validate()) {
      int subjectId;

      // kalau subject baru
      if (selectedSubject == null && _subjectController.text.isNotEmpty) {
        await DbHelper.insertSubject({'name': _subjectController.text});
        await _loadSubjects();
        subjectId = subjects.last.id!;
      } else {
        subjectId = selectedSubject!.id!;
      }

      final grade = GradeModel(
        studentId: 1, // sementara hardcode (bisa diganti dengan login ID)
        subjectId: subjectId,
        type: _typeController.text,
        score: double.parse(_scoreController.text),
      );

      await DbHelper.insertGrade(grade.toMap());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Grade berhasil ditambahkan')));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Grade"),
        backgroundColor: const Color(0xFF2567E8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<SubjectModel>(
                initialValue: selectedSubject,
                hint: const Text("Pilih Mata Pelajaran"),
                items: subjects.map((s) {
                  return DropdownMenuItem(value: s, child: Text(s.name));
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedSubject = value);
                },
              ),
              const SizedBox(height: 12),
              if (selectedSubject == null)
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    labelText: "Atau tambahkan mata pelajaran baru",
                    border: OutlineInputBorder(),
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(
                  labelText: "Jenis Nilai (misal: Quiz, Project, UTS)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Jenis nilai tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _scoreController,
                decoration: const InputDecoration(
                  labelText: "Skor",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Skor tidak boleh kosong' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _addGrade,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2567E8),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Simpan",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
