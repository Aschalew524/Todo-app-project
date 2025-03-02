const Todo = require("../models/todoModel");
const mongoose = require("mongoose");


// 🟢 Get all todos
exports.getAllTodos = async (req, res) => {
  try {
    if (!req.user || !req.user.id) {
      return res.status(401).json({ message: "Unauthorized. Please log in." });
    }
    const todos = await Todo.find({ user_id: req.user.id });
    res.status(200).json(todos);
  } catch (err) {
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// 🟢 Get a single todo by ID
exports.getTodoById = async (req, res) => {
  try {
    const todoId = req.params.id;
    const userId = req.user.id; // Get logged-in user ID

    console.log(`🔍 Fetching Todo: ID=${todoId}, UserID=${userId}`);

    // ✅ Ensure `user_id` is correctly queried as an ObjectId
    const todo = await Todo.findOne({ 
      _id: new mongoose.Types.ObjectId(todoId), 
      user_id: new mongoose.Types.ObjectId(userId) 
    });

    if (!todo) {
      console.log("🚨 Todo not found or does not belong to the user.");
      return res.status(404).json({ message: "Todo not found" });
    }

    console.log("✅ Found Todo:", todo);
    res.status(200).json(todo); // ✅ Send a single object, NOT a list
  } catch (error) {
    console.error("🚨 Error fetching todo:", error);
    res.status(500).json({ message: "Server error" });
  }
};


// 🟢 Create a todo
// 🟢 Create a To-Do
exports.createTodo = async (req, res) => {
  try {
    if (!req.user || !req.user.id) {
      return res.status(401).json({ message: "Unauthorized. Please log in." });
    }

    const { title, description = "" } = req.body;
    if (!title.trim()) {
      return res.status(400).json({ message: "Title is required" });
    }

    const todo = new Todo({ 
      title, 
      description, 
      user_id: req.user.id 
    });

    const savedTodo = await todo.save();
    res.status(201).json(savedTodo);
  } catch (err) {
    console.error("🚨 Error creating todo:", err);
    res.status(500).json({ message: "Internal Server Error" });
  }
};


// 🟢 Update a todo
exports.updateTodo = async (req, res) => {
  try {
    if (!req.user || !req.user.id) {
      return res.status(401).json({ message: "Unauthorized. Please log in." });
    }
    const todo = await Todo.findById(req.params.id);
    if (!todo) {
      return res.status(404).json({ message: "Todo not found" });
    }
    if (todo.user_id.toString() !== req.user.id) {
      return res.status(403).json({ message: "Not authorized to update this todo" });
    }
    const { title, description } = req.body;
    if (!title?.trim()) {
      return res.status(400).json({ message: "Title is required" });
    }
    todo.title = title;
    todo.description = description || "";
    const updatedTodo = await todo.save();
    res.status(200).json(updatedTodo);
  } catch (err) {
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// 🟢 Delete a todo
exports.deleteTodo = async (req, res) => {
  try {
    if (!req.user || !req.user.id) {
      return res.status(401).json({ message: "Unauthorized. Please log in." });
    }
    const todo = await Todo.findById(req.params.id);
    if (!todo) {
      return res.status(404).json({ message: "Todo not found" });
    }
    if (todo.user_id.toString() !== req.user.id) {
      return res.status(403).json({ message: "Not authorized to delete this todo" });
    }
    await todo.deleteOne();
    res.status(200).json({ message: "Todo deleted successfully" });
  } catch (err) {
    res.status(500).json({ message: "Internal Server Error" });
  }
};
