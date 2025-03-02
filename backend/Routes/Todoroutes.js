const express = require("express");
const { 
  getAllTodos, 
  getTodoById, 
  createTodo, 
  updateTodo, 
  deleteTodo 
} = require("../controllers/todo_controller"); // ✅ Make sure these functions exist

const validateToken = require("../middleware/validateTokenHandler");

const router = express.Router();

// Apply validateToken middleware to protect routes
router.use(validateToken);

// ✅ Define routes correctly
router.get("/", getAllTodos); // ✅ GET all todos
router.get("/:id", getTodoById); // ✅ GET a single todo by ID
router.post("/", createTodo); // ✅ Create a todo
router.put("/:id", updateTodo); // ✅ Update a todo
router.delete("/:id", deleteTodo); // ✅ Delete a todo

module.exports = router;
