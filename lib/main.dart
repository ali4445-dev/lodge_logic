import 'package:flutter/material.dart';
import 'package:lodge_logic/screens/auth/login_screen.dart';
import 'package:lodge_logic/screens/auth/sign_in_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Supabase.initialize(
      url: 'https://dicqpsjxmpusoelvtzza.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRpY3Fwc2p4bXB1c29lbHZ0enphIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQxOTIyNzksImV4cCI6MjA3OTc2ODI3OX0.B-ZF5mL4Hwzy57687UU1RejFTzsBBB_rSAy1E99w8XY',
    );
    print("Connection Successfull...");
  } catch (e) {
    print(e);
  }

  Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
    print("Session Refreshed");
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(body: SignInPage());
  }
}


// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Sign In',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const SignInPage(),
//     );
//   }
// }

// class SignInPage extends StatefulWidget {
//   const SignInPage({Key? key}) : super(key: key);

//   @override
//   State<SignInPage> createState() => _SignInPageState();
// }

// class _SignInPageState extends State<SignInPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _rememberMe = false;
//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F172A), // slate-900
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           bool isMobile = constraints.maxWidth < 768;

//           if (isMobile) {
//             return SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 children: [
//                   Container(
//                     color: const Color(0xFF0F172A),
//                     child: _buildImageSection(),
//                   ),
//                   _buildFormSection(),
//                 ],
//               ),
//             );
//           }

//           return Row(
//             children: [
//               Expanded(child: _buildImageSection()),
//               Expanded(
//                 child: _buildFormSection(),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildImageSection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: Center(
//         child: Image.asset(
//           'assets/images/signin-image.jpg',
//           fit: BoxFit.contain,
//           errorBuilder: (context, error, stackTrace) {
//             return Container(
//               height: 300,
//               color: Colors.grey[800],
//               child: const Icon(Icons.image, size: 100, color: Colors.white54),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildFormSection() {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         bool isMobile = constraints.maxWidth < 768;

//         return Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: isMobile
//                 ? const BorderRadius.only(
//                     topLeft: Radius.circular(55),
//                     topRight: Radius.circular(55),
//                   )
//                 : const BorderRadius.only(
//                     topLeft: Radius.circular(55),
//                     bottomLeft: Radius.circular(55),
//                   ),
//           ),
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.all(32.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 20),
//                     _buildHeader(),
//                     const SizedBox(height: 48),
//                     _buildEmailField(),
//                     const SizedBox(height: 32),
//                     _buildPasswordField(),
//                     const SizedBox(height: 24),
//                     _buildRememberAndForgot(),
//                     const SizedBox(height: 48),
//                     _buildSignInButton(),
//                     const SizedBox(height: 16),
//                     _buildDivider(),
//                     const SizedBox(height: 16),
//                     _buildGoogleButton(),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildHeader() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Sign in',
//           style: TextStyle(
//             fontSize: 36,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF0F172A),
//           ),
//         ),
//         const SizedBox(height: 24),
//         Row(
//           children: [
//             const Text(
//               "Don't have an account",
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Color(0xFF475569),
//               ),
//             ),
//             const SizedBox(width: 4),
//             GestureDetector(
//               onTap: () {
//                 // Navigate to register
//               },
//               child: const Text(
//                 'Register here',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Color(0xFF2563EB),
//                   fontWeight: FontWeight.w500,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildEmailField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Email',
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF0F172A),
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: _emailController,
//           keyboardType: TextInputType.emailAddress,
//           decoration: InputDecoration(
//             hintText: 'Enter email',
//             hintStyle: TextStyle(color: Colors.grey[400]),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//             enabledBorder: const UnderlineInputBorder(
//               borderSide: BorderSide(color: Color(0xFFCBD5E1)),
//             ),
//             focusedBorder: const UnderlineInputBorder(
//               borderSide: BorderSide(color: Color(0xFF1E293B), width: 2),
//             ),
//             suffixIcon: Icon(Icons.email_outlined, color: Colors.grey[400], size: 18),
//           ),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter your email';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildPasswordField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Password',
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF0F172A),
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: _passwordController,
//           obscureText: _obscurePassword,
//           decoration: InputDecoration(
//             hintText: 'Enter password',
//             hintStyle: TextStyle(color: Colors.grey[400]),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//             enabledBorder: const UnderlineInputBorder(
//               borderSide: BorderSide(color: Color(0xFFCBD5E1)),
//             ),
//             focusedBorder: const UnderlineInputBorder(
//               borderSide: BorderSide(color: Color(0xFF1E293B), width: 2),
//             ),
//             suffixIcon: IconButton(
//               icon: Icon(
//                 _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
//                 color: Colors.grey[400],
//                 size: 18,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _obscurePassword = !_obscurePassword;
//                 });
//               },
//             ),
//           ),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter your password';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildRememberAndForgot() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             SizedBox(
//               width: 20,
//               height: 20,
//               child: Checkbox(
//                 value: _rememberMe,
//                 onChanged: (value) {
//                   setState(() {
//                     _rememberMe = value ?? false;
//                   });
//                 },
//                 activeColor: const Color(0xFF2563EB),
//               ),
//             ),
//             const SizedBox(width: 8),
//             const Text(
//               'Remember me',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Color(0xFF475569),
//               ),
//             ),
//           ],
//         ),
//         GestureDetector(
//           onTap: () {
//             // Navigate to forgot password
//           },
//           child: const Text(
//             'Forgot Password?',
//             style: TextStyle(
//               fontSize: 14,
//               color: Color(0xFF2563EB),
//               fontWeight: FontWeight.w500,
//               decoration: TextDecoration.underline,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSignInButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: () {
//           if (_formKey.currentState!.validate()) {
//             // Handle sign in
//             print('Email: ${_emailController.text}');
//             print('Password: ${_passwordController.text}');
//           }
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF1E293B),
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(50),
//           ),
//           elevation: 0,
//         ),
//         child: const Text(
//           'Sign in',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             letterSpacing: 0.5,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDivider() {
//     return Row(
//       children: [
//         Expanded(child: Divider(color: Colors.grey[300])),
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16),
//           child: Text(
//             'or',
//             style: TextStyle(
//               fontSize: 14,
//               color: Color(0xFF0F172A),
//             ),
//           ),
//         ),
//         Expanded(child: Divider(color: Colors.grey[300])),
//       ],
//     );
//   }

//   Widget _buildGoogleButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: OutlinedButton(
//         onPressed: () {
//           // Handle Google sign in
//         },
//         style: OutlinedButton.styleFrom(
//           backgroundColor: const Color(0xFFF8FAFC),
//           foregroundColor: const Color(0xFF0F172A),
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           side: BorderSide(color: Colors.grey[300]!),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(50),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.network(
//               'https://www.google.com/favicon.ico',
//               width: 20,
//               height: 20,
//               errorBuilder: (context, error, stackTrace) {
//                 return const Icon(Icons.g_mobiledata, size: 24);
//               },
//             ),
//             const SizedBox(width: 16),
//             const Text(
//               'Continue with google',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
