import 'package:flutter/material.dart';
import 'package:lodge_logic/components/snackbar.dart';
import 'package:lodge_logic/screens/admin/admin_dashboard_page.dart';
import 'package:lodge_logic/screens/auth/components/input_fields.dart';
import 'package:lodge_logic/screens/auth/sign_up_screen.dart';
// import 'package:lodge_logic/screens/owner/owner_dashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // 🔵 BEAUTIFUL BLUE GRADIENT
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0D47A1), // dark blue
              Color(0xFF1976D2), // medium blue
              Color(0xFF42A5F5), // light blue
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),

                // LOGO
                const Icon(Icons.home_filled, color: Colors.white, size: 80),
                const SizedBox(height: 15),

                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // 📌 INPUT FIELDS
                StylishInputField(
                  label: "Email",
                  icon: Icons.email_outlined,
                  controller: _emailController,
                ),
                StylishInputField(
                  label: "Password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: _passwordController,
                ),

                // FORGOT PASSWORD
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       // TextButton(
                //       //   onPressed: () {},
                //       //   child: const Text(
                //       //     "Forgot Password?",
                //       //     style: TextStyle(color: Colors.white),
                //       //   ),
                //       // ),
                //     ],
                //   ),
                // ),

                const SizedBox(height: 10),

                // LOGIN BUTTON
                Container(
                  width: 260,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade600,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () async {
                      try {
                        final supabase = Supabase.instance.client;
                        final login = await supabase.auth.signInWithPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );

                        print(login.user!.userMetadata);
                        if (login.user != null) {
                          if (login.user!.userMetadata!["role"] ==
                              "Guest House Owner") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminDashboardPage(),
                              ),
                            );
                          } 
                          // else if (login.user!.userMetadata!["role"] ==
                          //     "Guest House Owner") {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => OwnerDashboard(authResponse : login),
                          //     ),
                          //   );
                          // }

                          showCustomSnackbar(
                            context: context,
                            message:
                                "User ${login.user!.email} logged in successfully",
                            type: SnackbarType.success,
                          );
                        }
                      } catch (e) {
                        showCustomSnackbar(
                          context: context,
                          message: e.toString(),
                          type: SnackbarType.error,
                        );
                      }
                    },
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // SIGNUP LINK
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.yellowAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
