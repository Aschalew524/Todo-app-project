import 'package:flutter/material.dart';
import 'package:todo_frontend/api_service.dart';

class TodoDetailsPage extends StatefulWidget {
  final String todoId;

  const TodoDetailsPage({super.key, required this.todoId});

  @override
  _TodoDetailsPageState createState() => _TodoDetailsPageState();
}

class _TodoDetailsPageState extends State<TodoDetailsPage> {
  Map<String, dynamic>? todoDetails;

  @override
  void initState() {
    super.initState();
    fetchTodoDetails();
  }

 Future<void> fetchTodoDetails() async {
  try {
    final details = await ApiService.getTodoById(widget.todoId);

    print("🔍 API Response: $details"); // Debugging

    if (details != null && details.isNotEmpty) {
      setState(() {
        todoDetails = details;
      });
    } else {
      print("🚨 API returned null or empty data");
    }
  } catch (e) {
    print("🚨 Error fetching todo details: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        backgroundColor: Colors.blue,
      ),
      body: todoDetails == null
          ? const Center(child: CircularProgressIndicator()) // Show loading if data is not yet available
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        todoDetails!['title'] ?? 'No Title',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        todoDetails!['description'] ?? 'No Description',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            (todoDetails!['completed'] ?? false) ? Icons.check_circle : Icons.pending, // ✅ Fix: Use 'completed'
                            color: (todoDetails!['completed'] ?? false) ? Colors.green : Colors.red,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Status: ${(todoDetails!['completed'] ?? false) ? 'Completed' : 'Pending'}',
                            style: TextStyle(
                              fontSize: 18,
                              color: (todoDetails!['completed'] ?? false) ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
