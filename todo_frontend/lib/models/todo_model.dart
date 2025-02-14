class Todo {
  final String id;
  final String title;
  final String description;
  final bool completed;

  Todo({
    required this.id,
    required this.title,
    this.description = '',
    this.completed = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
    );
  }
}