import 'package:edusmart/preferences/preferences_handler.dart';
import 'package:edusmart/services/firebase.dart';
import 'package:edusmart/view/admin/bottom_navigation_admin.dart';
import 'package:edusmart/view/guru/bottomnav.dart';
import 'package:edusmart/view/siswa/bottomnav.dart';
import 'package:flutter/material.dart';

class LoginEdu extends StatefulWidget {
  const LoginEdu({super.key});

  @override
  State<LoginEdu> createState() => _LoginEduState();
}

class _LoginEduState extends State<LoginEdu> {
  bool obscurepass = true;
  bool box = false;
  bool isbuttonenable = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void checkformfield() {
    setState(() {
      isbuttonenable =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Gradient background full screen
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff256BE8), Color(0xff1CE2DA)],
          ),
        ),
        // Biar full tinggi layar
        width: double.infinity,
        height: double.infinity,

        // Biar bisa scroll kalau isi melebihi layar
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Image.asset("assets/images/EduSmart.png", scale: 12),
              SizedBox(height: 4),
              // Kotak login
              Container(
                width: 343,
                height: 380,
                margin: const EdgeInsets.only(bottom: 40),
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Sign Up Row
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text("Don't have an account?"),
                    //     const SizedBox(width: 1),
                    //     TextButton(
                    //       onPressed: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => DaftarEdu(),
                    //           ),
                    //         );
                    //       },
                    //       child: Text(
                    //         "Sign Up",
                    //         style: TextStyle(color: Colors.blue),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 10),

                    // Email & Password
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Email"),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: emailController,
                              autovalidateMode: AutovalidateMode.onUnfocus,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Masukan Email Anda',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'email tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            Text("Password"),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: passwordController,
                              autovalidateMode: AutovalidateMode.onUnfocus,
                              obscureText: obscurepass,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Masukan Password anda',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscurepass = !obscurepass;
                                    });
                                  },
                                  icon: Icon(
                                    obscurepass
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password tidak boleh kosong';
                                }
                                if (value.length < 8) {
                                  return 'Password minimal 8 karakter';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Remember Me & Forgot
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     SizedBox(width: 8),
                    //     IconButton(
                    //       onPressed: () {
                    //         setState(() {
                    //           box = !box;
                    //         });
                    //       },
                    //       icon: Row(
                    //         children: [
                    //           Icon(
                    //             box
                    //                 ? Icons.check_box
                    //                 : Icons.check_box_outline_blank,
                    //           ),
                    //           Text("Remember Me"),
                    //         ],
                    //       ),
                    //     ),
                    //     // const Text("Remember Me"),
                    //     const Spacer(),
                    //     Padding(
                    //       padding: EdgeInsets.only(right: 18),
                    //       child: ButtonWidget(text: 'Forgot Password ?'),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 20),

                    // Login Button
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff1D61E7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;

                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();

                          try {
                            // 🔑 Pakai login function dari FirebaseServices
                            final user = await FirebaseServices.loginUser(
                              email: email,
                              password: password,
                            );

                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Email atau password salah"),
                                ),
                              );
                              return;
                            }

                            // 🔥 SAVE LOGIN + ROLE
                            await PreferenceHandler.saveLogin(true);
                            await PreferenceHandler.saveRole(
                              user.role ?? "siswa",
                            );

                            print("Login as: ${user.role}");

                            // 🚀 Navigasi berdasarkan role
                            if (user.role == "admin") {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BottomNavigationAdmin(),
                                ),
                              );
                            } else if (user.role == "guru") {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BottomNavGuru(),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BottomNavigationEDU(),
                                ),
                              );
                            }

                            // Snackbar sukses
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Login berhasil sebagai ${user.role}",
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Login gagal: $e")),
                            );
                          }
                        },
                        child: const Text(
                          "Log In",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    // Row ---OR---
                    // Padding(
                    //   padding: EdgeInsets.all(12),
                    //   child: Row(
                    //     children: [
                    //       Expanded(child: Divider(thickness: 1)),
                    //       SizedBox(width: 10),
                    //       Text("Or"),
                    //       SizedBox(width: 10),
                    //       Expanded(child: Divider(thickness: 1)),
                    //     ],
                    //   ),
                    // ),

                    // // Login Dengan Google dan Facebook
                    // SizedBox(
                    //   width: 300,
                    //   height: 50,
                    //   child: CustomLoginButton(
                    //     imagePath: ("assets/images/google.png"),
                    //     label: "Continue With Google",
                    //   ),
                    // ),
                    // SizedBox(height: 10),
                    // SizedBox(
                    //   width: 300,
                    //   height: 50,
                    //   child: CustomLoginButton(
                    //     imagePath: ("assets/images/facebook.png"),
                    //     label: "Continue With Facebook",
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
