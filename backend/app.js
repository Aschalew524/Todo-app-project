console.log('Hello from app.js');
const express = require('express');

const errorHandler = require('./middleware/errorhandler');
const dotenv = require('dotenv');
const connectDB = require('./config/dbconnection');

dotenv.config();
connectDB();

const app = express();

// Middleware to parse JSON
app.use(express.json());

// Routes
app.use('/api', require('./Routes/Todoroutes'));

// Error Handling Middleware (MUST be last)
app.use(errorHandler);

const port = process.env.PORT || 5000;
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
