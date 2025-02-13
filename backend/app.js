console.log('Hello from app.js');
const express = require('express');

const dotenv = require('dotenv');
const { connect } = require('mongoose');
const connectDB = require('./config/dbconnection');
const { getAllTodos } = require('./controllers/todo_controller');
dotenv.config();

connectDB();



const app = express();

const port = process.env.PORT || 5000;

app.use("/api/todos", require('./Routes/Todoroutes'));         

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
