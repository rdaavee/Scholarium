// index.js
require("dotenv").config();
const express = require("express");
const http = require("http");
const socketIo = require("socket.io");
const cors = require("cors");
const bodyParser = require("body-parser");
const connectDB = require("./db"); 
const userRoutes = require("./routers/user_routes");
const professorRoutes = require("./routers/professor_routes");
const adminRoutes = require("./routers/admin_routes");
const authRoutes = require("./routers/authentication_routes");
const path = require("path");
const Message = require("./models/message_system_model");

const app = express();
const PORT = process.env.PORT || 3000;

// Connect to the database
connectDB();

// Middleware setup
app.use(cors());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use("/uploads", express.static(path.join(__dirname, "uploads")));
// Routes setup
app.use("/api/user", userRoutes);
app.use("/api/prof", professorRoutes);
app.use("/api/admin", adminRoutes);
app.use("/api/auth", authRoutes);

// Create an HTTP server for Socket.IO
const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: "*", // Allow any origin, adjust as needed
    methods: ["GET", "POST"],
  },
});
app.set('io', io);
// Socket.IO connection handling
io.on("connection", (socket) => {
  console.log("New client connected:", socket.id);

  // Listen for incoming messages from the client
  socket.on("sendMessage", async (messageData) => {
    const { sender, receiver, content } = messageData;

    // Logic for saving and emitting messages can be handled in a separate function or controller
    const senderUser = await User.findOne({ school_id: sender });
    const receiverUser = await User.findOne({ school_id: receiver });

    if (senderUser && receiverUser) {
      const message = new Message({
        sender: senderUser._id,
        receiver: receiverUser._id,
        content,
      });
      await message.save();

      // Emit the message to the specific receiver
      socket.to(receiver).emit("receiveMessage", {
        sender: senderUser.school_id,
        content: message.content,
        timestamp: message.createdAt,
      });
    }
  });

  // Disconnect event
  socket.on("disconnect", () => {
    console.log("Client disconnected:", socket.id);
  });
});

// Start the server
server.listen(PORT, "0.0.0.0", () => {
  console.log(`Server is running on port ${PORT}`);
});
