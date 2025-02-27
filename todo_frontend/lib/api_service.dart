import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://localhost:3001';

  // Sign-In
  static Future<http.Response?> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        return null; // Return null if request fails
      }
    } catch (e) {
      print("Sign-In Error: $e"); // Debugging purposes
      return null; // Return null on network error
    }
  }

  // Sign-Up
  static Future<http.Response?> signUp(String userName, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_name': userName, 'email': email, 'password': password}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        return null; // Return null if request fails
      }
    } catch (e) {
      print("Sign-Up Error: $e"); // Debugging purposes
      return null; // Return null on network error
    }
  }
}
