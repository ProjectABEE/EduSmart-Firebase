import 'package:edusmart/firebase_options.dart';
import 'package:edusmart/providers/attendance_provider.dart';
import 'package:edusmart/providers/grade_provider.dart';
import 'package:edusmart/providers/schedule_provider.dart';
import 'package:edusmart/providers/subject_provider.dart';
import 'package:edusmart/providers/user_provider.dart';
import 'package:edusmart/view/spalshscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: "https://nsgboiigqzckqwaunyux.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5zZ2JvaWlncXpja3F3YXVueXV4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQxMjE0NTEsImV4cCI6MjA3OTY5NzQ1MX0.3QeDHdifdyRXrc-RolIe6D33d_sKeTzbGewXoTZWWsc",
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()..fetchUser()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => SubjectProvider()),
        ChangeNotifierProvider(create: (_) => GradeProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduSmart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const SplashScreen(),
    );
  }
}
