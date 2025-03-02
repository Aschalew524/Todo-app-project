import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3001';

  // 🔹 Sign-In
  static Future<Map<String, dynamic>?> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print("📤 Sending Sign-In Request...");
      print("📥 Response Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData.containsKey('accessToken')) {
          String token = responseData['accessToken'];

          // ✅ Save token to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);

          print("✅ Token Saved: $token");

          return {
            'success': true,
            'token': token,
            'user': responseData['user'],
          };
        }
      }

      print("❌ Sign-In Failed: ${response.body}");
      return {'success': false, 'message': 'Invalid credentials'};
    } catch (e) {
      print("🚨 Sign-In Error: $e");
      return {'success': false, 'message': 'Network error, please try again'};
    }
  }

  // 🔹 Sign-Up
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
        print("❌ Sign-Up Failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🚨 Sign-Up Error: $e");
      return null;
    }
  }

  // 🔹 Fetch All To-Dos
  static Future<List<dynamic>> fetchTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) throw Exception("User is not logged in");

      final response = await http.get(
        Uri.parse('$baseUrl/api/todos'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      );

      print("📥 Response Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("❌ Fetch Todos Failed: ${response.body}");
        return [];
      }
    } catch (e) {
      print("🚨 Error fetching todos: $e");
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getTodoById(String todoId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception("User is not logged in");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/todos/$todoId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("📥 Response Status Code: ${response.statusCode}");
    print("📥 Raw Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);

      if (responseData is Map<String, dynamic> && responseData.containsKey("_id")) {
        print("✅ Parsed Todo Data: $responseData");
        return responseData;
      } else {
        print("🚨 API returned unexpected format. Expected a single object but got: $responseData");
        return null;
      }
    } else {
      print("❌ Fetch Todo Failed: ${response.body}");
      return null;
    }
  } catch (e) {
    print("🚨 Error fetching todo: $e");
    return null;
  }
}



 // 🔹 Create a To-Do
static Future<bool> createTodo(String title, String description) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) throw Exception("User is not logged in");

    final response = await http.post(
      Uri.parse('$baseUrl/api/todos'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'description': description,
      }),
    );

    print("📥 Response Status Code: ${response.statusCode}");
    print("📥 Response Body: ${response.body}");

    if (response.statusCode == 201) {
      return true;
    } else {
      print("❌ Create Todo Failed: ${response.body}");
      return false;
    }
  } catch (e) {
    print("🚨 Error creating todo: $e");
    return false;
  }
}


  // 🔹 Update a To-Do
  static Future<bool> updateTodo(String todoId, String title, String description) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) throw Exception("User is not logged in");

      final response = await http.put(
        Uri.parse('$baseUrl/api/todos/$todoId'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode({'title': title, 'description': description}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        print("❌ Update Todo Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("🚨 Error updating todo: $e");
      return false;
    }
  }

  // 🔹 Delete a To-Do
  static Future<bool> deleteTodo(String todoId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) throw Exception("User is not logged in");

      final response = await http.delete(
        Uri.parse('$baseUrl/api/todos/$todoId'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        print("❌ Delete Todo Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("🚨 Error deleting todo: $e");
      return false;
    }
  }
}
