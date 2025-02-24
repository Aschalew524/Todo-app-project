import 'package:flutter/material.dart';
import 'package:todo_frontend/screens/home_screen.dart';
//import 'package:todo_frontend/screens/signin.dart';
// import 'package:todo_frontend/screens/home_screen.dart';
//import 'package:todo_frontend/screens/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(

      debugShowCheckedModeBanner: false, 
      home: HomeScreen()//SignInScreen(),
    );
  }
}