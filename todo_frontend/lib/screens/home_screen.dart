import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header Section
          Container(
            height: 250,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Centers the column's content
                children: [
                  CircleAvatar(
                    radius: 50, // Adjust the radius for the desired size
                    backgroundImage: NetworkImage(
                      "https://via.placeholder.com/150",
                    ),
                  ),
                  SizedBox(height: 10), // Space between avatar and text
                  Text(
                    "Welcome back Aschalew",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "Tasks List",
              style: TextStyle(
                fontSize: 28,
                color: Colors.black,
              ),
            ),
          ),
          // Task List Section
          Expanded(
            child: ListView.builder(
              itemCount: 7, // Replace with your actual task count
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(Icons.task, color: Colors.blue), // Task icon
                    title: Text(
                      "Task ${index + 1}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Description for Task ${index + 1}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Checkbox(
                      value: false, // Replace with your task completion state
                      onChanged: (value) {
                        // Handle checkbox state change
                      },
                    ),
                    onTap: () {
                      // Navigate to To-Do Details Screen with task details
                      Navigator.pushNamed(
                        context,
                        '/details',
                        arguments: {
                          'title': 'Task ${index + 1}', // Pass task title
                          'description': 'Description for Task ${index + 1}', // Pass task description
                          'isCompleted': false, // Pass task status
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Floating Action Button (FAB)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Create To-Do Screen
          Navigator.pushNamed(context, '/create');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}