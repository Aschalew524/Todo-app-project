const asyncHandler = require("express-async-handler");
const jwt = require("jsonwebtoken");

const validateToken = asyncHandler(async (req, res, next) => {
    console.log("Validating token...");

    let token;
    let authHeader = req.headers.authorization || req.headers.Authorization;

    console.log("Authorization Header:", authHeader); // Log the Authorization header

    if (authHeader && authHeader.startsWith("Bearer")) {
        token = authHeader.split(" ")[1];

        console.log("Token:", token);

        jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, decoded) => {
            if (err) {
                console.log("Token Verification Error:", err);
                res.status(401).json({ message: "Not authorized, token failed" });
                return;
            }

            console.log("Decoded Payload:", decoded); // Log the entire decoded payload
            req.user = decoded.user; // Attach the user to the request object
            next();
        });
    } else {
        console.log("No token found");
        res.status(401).json({ message: "Not authorized, no token" });
    }
});

module.exports = validateToken;