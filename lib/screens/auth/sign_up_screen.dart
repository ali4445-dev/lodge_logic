import 'package:flutter/material.dart';
import 'package:lodge_logic/components/snackbar.dart';
import 'package:lodge_logic/models/user_profile.dart';
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
  final TextEditingController confirmPasswordController =TextEditingController();

  String selectedRole = "Customer";
  bool obscurePass = true;
  bool obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0052D4), Color(0xFF4364F7), Color(0xFF6FB1FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              const Icon(Icons.person_add_alt, size: 60, color: Colors.white),
              const SizedBox(height: 10),
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
              _inputField(
                controller: nameController,
                icon: Icons.person,
                hint: "Full Name",
              ),

              const SizedBox(height: 18),

              // Email
              _inputField(
                controller: emailController,
                icon: Icons.email,
                hint: "Email",
              ),

              const SizedBox(height: 18),

              // Role Dropdown
              _roleDropdown(),

              const SizedBox(height: 18),

              // Password
              _inputField(
                controller: passwordController,
                icon: Icons.lock,
                hint: "Password",
                isPassword: true,
                obscureText: obscurePass,
                toggle: () {
                  setState(() => obscurePass = !obscurePass);
                },
              ),

              const SizedBox(height: 18),

              // Confirm Password
              _inputField(
                controller: confirmPasswordController,
                icon: Icons.lock_outline,
                hint: "Confirm Password",
                isPassword: true,
                obscureText: obscureConfirm,
                toggle: () {
                  setState(() => obscureConfirm = !obscureConfirm);
                },
              ),

              const SizedBox(height: 30),

              // Sign Up Button
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 3),
                      blurRadius: 8,
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
                        role: selectedRole,
                      );
                    } catch (e) {
                      showCustomSnackbar(
                        context: context,
                        message: e.toString(),
                        type: SnackbarType.error,
                      );
                    }

                    // TODO: Add Supabase Sign Up Logic
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

  // ---------------- INPUT FIELD WIDGET ----------------
  Widget _inputField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? toggle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.blue),
          border: InputBorder.none,
          hintText: hint,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: toggle,
                )
              : null,
        ),
      ),
    );
  }

  // ---------------- ROLE DROPDOWN ----------------
  Widget _roleDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedRole,
        decoration: const InputDecoration(border: InputBorder.none),
        items: const [
          DropdownMenuItem(value: "Customer", child: Text("Customer")),
          DropdownMenuItem(
            value: "Guest House Owner",
            child: Text("Guest House Owner Account"),
          ),
        ],
        onChanged: (value) {
          setState(() {
            selectedRole = value!;
          });
        },
      ),
    );
  }
}
