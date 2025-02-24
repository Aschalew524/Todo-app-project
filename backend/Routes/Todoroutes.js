const express = require("express");
const { getAllTodos, createTodo, updateTodo, deleteTodo } = require("../controllers/todo_controller");
const validateToken = require("../middleware/validateTokenHandler");

const router = express.Router();

// Apply validateToken middleware to protect routes
router.use(validateToken);

// Define routes
router.get("/", getAllTodos); // GET /api/todos
router.post("/", createTodo); // POST /api/todos
router.put("/:id", updateTodo); // PUT /api/todos/:id
router.delete("/:id", deleteTodo); // DELETE /api/todos/:id

module.exports = router;  //