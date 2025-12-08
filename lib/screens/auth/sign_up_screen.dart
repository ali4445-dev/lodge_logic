import 'package:flutter/material.dart';
import 'package:lodge_logic/components/snackbar.dart';
import 'package:lodge_logic/screens/auth/components/input_fields.dart';
import 'package:lodge_logic/screens/auth/methods/sign_up.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // String selectedRole = \"Customer\";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.home_filled, size: 80, color: Colors.white),
              const SizedBox(height: 15),
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 35),

              // Name
              StylishInputField(
                label: "Full Name",
                icon: Icons.person_outlined,
                controller: nameController,
              ),
              const SizedBox(height: 15),

              // Email
              StylishInputField(
                label: "Email",
                icon: Icons.email_outlined,
                controller: emailController,
              ),
              const SizedBox(height: 15),

              // Role Dropdown
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              //   child: Container(
              //     padding: const EdgeInsets.symmetric(horizontal: 15),
              //     decoration: BoxDecoration(
              //       // filled: true,
              //       // fillColor: Colors.white.withOpacity(0.9),
              //       borderRadius: BorderRadius.circular(15),
              //       // border:Box OutlineInputBorder(
              //       //   borderRadius: BorderRadius.circular(15),
              //       //   borderSide: BorderSide.none,
              //       // ),
              //     ),
              //     child: DropdownButtonFormField<String>(
              //       value: selectedRole,
              //       decoration: const InputDecoration(
              //         border: InputBorder.none,
              //         prefixIcon: Icon(Icons.person_3_outlined, color: Colors.blueAccent),
              //       ),
              //       items: const [
              //         DropdownMenuItem(value: "Customer", child: Text("Customer")),
              //         DropdownMenuItem(
              //           value: "Guest House Owner",
              //           child: Text("Guest House Owner"),
              //         ),
              //       ],
              //       onChanged: (value) {
              //         setState(() {
              //           selectedRole = value!;
              //         });
              //       },
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 15),

              // Password
              StylishInputField(
                label: "Password",
                icon: Icons.lock_outline,
                isPassword: true,
                controller: passwordController,
              ),
              const SizedBox(height: 15),

              // Confirm Password
              StylishInputField(
                label: "Confirm Password",
                icon: Icons.lock_outline,
                isPassword: true,
                controller: confirmPasswordController,
              ),
              const SizedBox(height: 30),

              // Sign Up Button
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
                    String name = nameController.text.trim();
                    String email = emailController.text.trim();
                    String pass = passwordController.text.trim();
                    String confirm = confirmPasswordController.text.trim();

                    if (pass != confirm) {
                      showCustomSnackbar(
                        context: context,
                        message: "Password does not match to confirm password",
                        type: SnackbarType.error,
                      );
                      return;
                    }
                    try {
                      await signUpUser(
                        name: name,
                        email: email,
                        password: pass,
                        role: "owner",
                      );
                      showCustomSnackbar(
                        context: context,
                        message: "Account created successfully! Please login.",
                        type: SnackbarType.success,
                      );
                      if (mounted) {
                        Navigator.pop(context);
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
                    "SIGN UP",
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.2,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Already have account?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
