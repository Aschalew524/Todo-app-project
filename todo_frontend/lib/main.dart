import 'package:flutter/material.dart';
import 'package:todo_frontend/screens/AddTodoPage.dart';
import 'package:todo_frontend/screens/detailsPage.dart';
import 'package:todo_frontend/screens/home_screen.dart';
import 'package:todo_frontend/screens/signin.dart';
import 'package:todo_frontend/screens/signup.dart';
import 'api_service.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      initialRoute: '/signin', // Start with the Sign-In screen
      routes: {
        '/signin': (context) => SignInScreen(), // Sign-In route
        '/signup': (context) => SignupScreen(), // Sign-Up route
        '/home': (context) => HomeScreen(), // Home route
        '/create': (context) => CreateTodoPage(), // Create To-Do route
        '/details': (context) => const TodoDetailsPage(
              title: 'Sample Task', // Pass sample data for now
              description: 'This is a sample task description.',
              isCompleted: false,
            ), // To-Do Details route
      },
    );
  }
}