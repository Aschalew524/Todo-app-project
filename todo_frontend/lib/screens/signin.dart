import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: const Color(0xFFE0F7EF),
      body:Column(
          
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
            children: [Image(
            image: AssetImage('assets/login.png'), // Use your asset path
          ),],),
           
            const SizedBox(height: 40), // Spacing

            // Email Field
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
               child: TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                           ),
             ),
            const SizedBox(height: 40), // Spacing

            // Password Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
              
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
            const SizedBox(height: 40), // Spacing

            // Sign-In Button
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
               child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add sign-in functionality
                  },
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
            const SizedBox(height: 40), // Spacing

            // Sign-Up Option
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    // Navigate to Sign-Up screen
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
}