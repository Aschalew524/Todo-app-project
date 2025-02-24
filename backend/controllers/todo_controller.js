const Todo = require('../models/todoModel');

// Get all todos for the authenticated user
exports.getAllTodos = async (req, res) => {
  try {
    const todos = await Todo.find({ user_id: req.user.id }); // Use user_id
    res.json(todos);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Create a new todo
exports.createTodo = async (req, res) => {
  console.log('Request Body:', req.body); 
  try {
    const { title, description } = req.body;

    // Validate input fields
    if (!title) {
      return res.status(400).json({ message: "Title is required" });
    }

    // Create the todo
    const todo = new Todo({
      title,
      description,
      user_id: req.user.id, // Use user_id
    });

    const savedTodo = await todo.save();
    res.status(201).json(savedTodo);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// Update a todo
exports.updateTodo = async (req, res) => {
  try {
    const todo = await Todo.findById(req.params.id);

    // Check if the todo exists
    if (!todo) {
      return res.status(404).json({ message: "Todo not found" });
    }

    // Check if the todo belongs to the authenticated user
    if (todo.user_id.toString() !== req.user.id) { // Use user_id
      return res.status(403).json({ message: "Not authorized to update this todo" });
    }

    // Update the todo
    const updatedTodo = await Todo.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(updatedTodo);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// Delete a todo
exports.deleteTodo = async (req, res) => {
  try {
    const todo = await Todo.findById(req.params.id);

    // Check if the todo exists
    if (!todo) {
      return res.status(404).json({ message: "Todo not found" });
    }

    // Check if the todo belongs to the authenticated user
    if (todo.user_id.toString() !== req.user.id) { // Use user_id
      return res.status(403).json({ message: "Not authorized to delete this todo" });
    }

    // Delete the todo
    await Todo.findByIdAndDelete(req.params.id);
    res.json({ message: "Todo deleted successfully" });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};