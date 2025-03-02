import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_frontend/api_service.dart';
import 'package:todo_frontend/screens/detailsPage.dart';

// Import your API service

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> tasks = []; // Stores fetched tasks
  bool isLoading = true; // Controls loading indicator

  @override
@override
void initState() {
  super.initState();
  debugToken();
  fetchUserTasks();
}

Future<void> debugToken() async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  print("🛠️ Retrieved Token: $token");
}


  // Fetch tasks from the API
  Future<void> fetchUserTasks() async {
    try {
      List<dynamic> fetchedTasks = await ApiService.fetchTodos();
      setState(() {
        tasks = fetchedTasks;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching tasks: $e");
      setState(() => isLoading = false);
    }
  }

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
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(""),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Welcome back, Aschalew",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator()) // Show loader while fetching
                : tasks.isEmpty
                    ? const Center(child: Text("No tasks found"))
                    : ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          var task = tasks[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            elevation: 3,
                            child: ListTile(
                              leading: const Icon(Icons.task, color: Colors.blue),
                              title: Text(
                                task['title'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                task['description'] ?? "No description",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: Checkbox(
                                value: task['isCompleted'] ?? false, // Handle task completion
                                onChanged: (value) {
                                  // Handle checkbox state change (optional)
                                },
                              ),
                             onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TodoDetailsPage(todoId: task['_id']),
    ),
  );
},
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
