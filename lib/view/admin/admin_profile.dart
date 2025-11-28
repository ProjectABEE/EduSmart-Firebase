import 'package:edusmart/preferences/preferences_handler.dart';
import 'package:edusmart/view/auth/loginedu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Profile")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              PreferenceHandler.removeLogin();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginEdu()),
                (route) => false,
              );
            },
            child: const Row(
              children: [
                Icon(Icons.logout, color: Colors.red),
                SizedBox(width: 8),
                Text("Logout", style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
