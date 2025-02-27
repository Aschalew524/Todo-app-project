const express = require("express");
const dotenv = require("dotenv");
const connectDB = require("./config/dbconnection");
const authRoutes = require("./Routes/authroutes");
const todoRoutes = require("./Routes/Todoroutes");
const errorHandler = require("./middleware/errorhandler");

// Load environment variables
dotenv.config();

// Connect to the database
connectDB();

const app = express();
const cors = require('cors');

app.use(cors()); // Allow all origins


// Middleware to parse JSON
app.use(express.json());

// Routes
app.use("/api/auth", authRoutes); // Authentication routes
app.use("/api/todos", todoRoutes); // Todo routes

// Error Handling Middleware (MUST be last)
app.use(errorHandler);

const port = process.env.PORT || 3001;
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});