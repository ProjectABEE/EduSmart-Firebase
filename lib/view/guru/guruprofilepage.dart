import 'package:edusmart/preferences/preferences_handler.dart';
import 'package:edusmart/view/auth/loginedu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TeacherProfilePage extends StatelessWidget {
  const TeacherProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Teacher Profile"),
        backgroundColor: Color(0xFF256BE8),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.shade100,
                child: Icon(Icons.person, size: 60, color: Colors.blue),
              ),
            ),

            SizedBox(height: 20),

            /// Name
            Text("Name", style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text(
              user?.displayName ?? "Guru",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            /// Email
            Text("Email", style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text(user?.email ?? "-", style: TextStyle(fontSize: 18)),

            Spacer(),

            /// Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  PreferenceHandler.removeLogin();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginEdu()),
                    (route) => false,
                  );
                },
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text(
                  "Logout",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
