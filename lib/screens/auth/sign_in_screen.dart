import 'package:flutter/material.dart';
import 'package:lodge_logic/components/snackbar.dart';
import 'package:lodge_logic/screens/admin/admin_dashboard.dart';
import 'package:lodge_logic/screens/admin/admin_dashboard_page.dart';
import 'package:lodge_logic/screens/auth/sign_up_screen.dart';
import 'package:lodge_logic/screens/owner/owner_dashboard.dart';
import 'package:lodge_logic/screens/owner/ownerdashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // slate-900
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 768;

          if (isMobile) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    color: const Color(0xFF0F172A),
                    child: _buildImageSection(),
                  ),
                  _buildFormSection(),
                ],
              ),
            );
          }

          return Row(
            children: [
              Expanded(child: _buildImageSection()),
              Expanded(child: _buildFormSection()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Image.asset(
          'assets/images/signin-image.jpg',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 300,
              color: Colors.grey[800],
              child: const Icon(Icons.image, size: 100, color: Colors.white54),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 768;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: isMobile
                ? const BorderRadius.only(
                    topLeft: Radius.circular(55),
                    topRight: Radius.circular(55),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(55),
                    bottomLeft: Radius.circular(55),
                  ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    _buildHeader(),
                    const SizedBox(height: 48),
                    _buildEmailField(),
                    const SizedBox(height: 32),
                    _buildPasswordField(),
                    const SizedBox(height: 24),
                    _buildRememberAndForgot(),
                    const SizedBox(height: 48),
                    _buildSignInButton(),
                    const SizedBox(height: 16),
                    _buildDivider(),
                    const SizedBox(height: 16),
                    _buildGoogleButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sign in',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Text(
              "Don't have an account",
              style: TextStyle(fontSize: 14, color: Color(0xFF475569)),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                // Navigate to register
              },
              child: const Text(
                'Register here',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Enter email',
            hintStyle: TextStyle(color: Colors.grey[400]),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 12,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFCBD5E1)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF1E293B), width: 2),
            ),
            suffixIcon: Icon(
              Icons.email_outlined,
              color: Colors.grey[400],
              size: 18,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Enter password',
            hintStyle: TextStyle(color: Colors.grey[400]),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 12,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFCBD5E1)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF1E293B), width: 2),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey[400],
                size: 18,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRememberAndForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
                activeColor: const Color(0xFF2563EB),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Remember me',
              style: TextStyle(fontSize: 14, color: Color(0xFF475569)),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            // Navigate to forgot password
          },
          child: const Text(
            'Forgot Password?',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF2563EB),
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            //
            try {
              final supabase = Supabase.instance.client;
              final login = await supabase.auth.signInWithPassword(
                email: _emailController.text,
                password: _passwordController.text,
              );

              print(login.user!.userMetadata);
              if (login.user != null) {
                if (login.user!.userMetadata!["role"] == "Guest House Admin") {
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>AdminDashboardPage(),
                    ),
                  );
                } else if (login.user!.userMetadata!["role"] ==
                    "Guest House Owner") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>DashboardOverviewScreen(),
                    ),
                  );
                }

                showCustomSnackbar(
                  context: context,
                  message: "User ${login.user!.email} logged in successfully",
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

            // Handle sign in
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E293B),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Sign in',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          // Handle Google sign in
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFF8FAFC),
          foregroundColor: const Color(0xFF0F172A),
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://www.google.com/favicon.ico',
              width: 20,
              height: 20,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.g_mobiledata, size: 24);
              },
            ),
            const SizedBox(width: 16),
            const Text(
              'Continue with google',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
