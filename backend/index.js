require("dotenv").config();
const express = require("express");
const http = require("http");
const cors = require("cors");
const bodyParser = require("body-parser");
const connectDB = require("./db"); 
const userRoutes = require("./routers/user_routes");
const professorRoutes = require("./routers/professor_routes");
const adminRoutes = require("./routers/admin_routes");
const authRoutes = require("./routers/authentication_routes");
const path = require("path");
const setupChatSocket = require('./sockets/chat_socket'); // Import socket setup
const app = express();
const PORT = process.env.PORT || 3000;

// Create HTTP server
const server = http.createServer(app);

// Connect to the database
connectDB();

// Setup socket.io
const io = setupChatSocket(server);

// Middleware setup
app.use(cors());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

// Store io in app for easy access in routes
app.set('io', io);

// Routes setup
app.use("/api/user", userRoutes);
app.use("/api/prof", professorRoutes);
app.use("/api/admin", adminRoutes);
app.use("/api/auth", authRoutes);

// Start the server
server.listen(PORT, "0.0.0.0", () => {
  console.log(`Server is running on port ${PORT}`);
});
