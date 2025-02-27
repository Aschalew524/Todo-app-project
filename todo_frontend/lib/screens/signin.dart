import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_frontend/api_service.dart';  // Import API service
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Controllers for text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Function to handle sign-in
  void loginUser(BuildContext context) async {
  String email = emailController.text.trim();
  String password = passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    showAlertDialog(context, "⚠️ Please enter both email and password!");
    return;
  }

  try {
    final response = await ApiService.signIn(email, password);

    if (response == null) {
      showAlertDialog(context, "🚨 Server is not responding. Please try again later.");
      return;
    }

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}"); // Debugging output

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    // 🔹 **Handle incorrect credentials (401)**
    if (response.statusCode == 401) {
      showAlertDialog(context, "❌ Invalid email or password!");
      return;
    }

    // 🔹 **Handle other bad requests (400)**
    if (response.statusCode == 400) {
      String errorMessage = responseData['message'] ?? "Invalid input. Please try again.";
      showAlertDialog(context, "❌ $errorMessage");
      return;
    }

    // 🔹 **Handle server errors (500)**
    if (response.statusCode >= 500) {
      showAlertDialog(context, "🚨 Server error. Please try again later.");
      return;
    }

    // ✅ **Login successful**
    if (response.statusCode == 200 && responseData.containsKey('accessToken')) {
      String token = responseData['accessToken'];

      // ✅ Save token for future requests
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Login successful!")),
      );

      Navigator.pushReplacementNamed(context, '/home'); // Navigate to home
    } else {
      showAlertDialog(context, "❌ Unexpected response from server. Please try again.");
    }
  } catch (e) {
    print("❌ Error: $e"); // Debugging output
    showAlertDialog(context, "⚠️ An unexpected error occurred. Please check your connection and try again.");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7EF),
      body: Column(
        children: [
          const SizedBox(height: 50),
          Text(
            "Welcome Back!",
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Let's help you to meet your tasks",
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 40),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('assets/login.png')),
            ],
          ),
          const SizedBox(height: 40),

          // Email Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: emailController, // Connect to controller
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Password Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: passwordController, // Connect to controller
              obscureText: true, // Hide password
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Sign-In Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => loginUser(context), // ✅ Pass context correctly
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Sign-Up Option
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account? "),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Function to show an alert (Fixed signature)
  void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
