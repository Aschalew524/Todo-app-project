const asyncHandler = require("express-async-handler");
const User = require("../models/authmodel");
const bcrypt = require("bcrypt");  // Used to encrypt password
const jwt = require("jsonwebtoken");

const registerUser = asyncHandler(async (req, res) => {
   const { user_name, email, password } = req.body;

   // Validate input fields
   if (!user_name || !email || !password) {
       res.status(400);
       throw new Error("Please enter all fields");
   }  

   // Check if user already exists
   const userAvailable = await User.findOne({ email });
   if (userAvailable) {
       res.status(400);
       throw new Error("User already exists");
   }

   // Hash the password
   const hashedPassword = await bcrypt.hash(password, 10);
   console.log(hashedPassword);

   // Create the user
   const user = await User.create({
       user_name,
       email,
       password: hashedPassword
   });

   // Send a single response
   res.status(201).json({ user, message: "User registered successfully" });
});



const loginUser = asyncHandler(async (req, res) => {
    const { email, password } = req.body;

    // Validate input fields
    if (!email || !password) {
        return res.status(400).json({ message: "Please enter both email and password" });
    }

    // Find the user
    const user = await User.findOne({ email });

    if (!user) {
        // 🔹 User not found (Wrong email)
        return res.status(401).json({ message: "Invalid email or password" });
    }

    // Compare passwords
    const passwordMatch = await bcrypt.compare(password, user.password);
    if (!passwordMatch) {
        // 🔹 Password incorrect
        return res.status(401).json({ message: "Invalid email or password" });
    }

    // 🔹 Generate access token
    const accessToken = jwt.sign(
        {
            user: {
                user_name: user.user_name,
                email: user.email,
                id: user.id,
            },
        },
        process.env.ACCESS_TOKEN_SECRET,
        { expiresIn: "30m" }
    );

    // 🔹 Return token and user data
    res.status(200).json({ 
        accessToken, 
        user: { id: user.id, email: user.email, user_name: user.user_name } 
    });
});



const currentUser = asyncHandler(async (req, res) => {
    console.log("Request User:", req.user);

    if (!req.user) {
        res.status(404);
        throw new Error("User not found");
    }

    res.status(200).json({
        id: req.user.id,
        user_name: req.user.user_name,
        email: req.user.email,
    });
});


module.exports = { currentUser, registerUser, loginUser };