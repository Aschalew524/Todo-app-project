import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_frontend/api_service.dart'; // Import your API service

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controllers for input fields
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void registerUser() async {
    String userName = userNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Step 1: Check if any field is empty
    if (userName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showAlertDialog("All fields are required!");
      return;
    }

    // Step 2: Check if passwords match
    if (password != confirmPassword) {
      showAlertDialog("Passwords do not match!");
      return;
    }

    // Step 3: Send request only if validation passes
    final response = await ApiService.signUp(userName, email, password);

    if (!mounted) return; // Prevent async errors if widget is removed

    if (response?.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sign-up successful!"), backgroundColor: Colors.green),
      );
      Navigator.pushReplacementNamed(context, '/signin');
    } else {
      showAlertDialog("Error: ${response?.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7EF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Text(
                "Welcome OnBoard!",
                style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              Text(
                "Let's help you to meet your tasks",
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 40),

              // Input Fields
              _buildInputField("Enter your full name", controller: userNameController),
              const SizedBox(height: 20),
              _buildInputField("Enter your email", controller: emailController),
              const SizedBox(height: 20),
              _buildInputField("Enter password", controller: passwordController, obscureText: true),
              const SizedBox(height: 20),
              _buildInputField("Confirm password", controller: confirmPasswordController, obscureText: true),

              const SizedBox(height: 30),

              // Register Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BFA6),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 5,
                  ),
                  child: Text(
                    "Register",
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Sign In Option
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: GoogleFonts.poppins(color: Colors.black54)),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/signin'),
                    child: Text("Sign in", style: GoogleFonts.poppins(color: Colors.teal, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Input Field Widget
  Widget _buildInputField(String hint, {bool obscureText = false, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.black38),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Show Alert Dialog
  void showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
