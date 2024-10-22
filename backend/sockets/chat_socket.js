const { Server } = require("socket.io");
const User = require('../models/user_model');
const Message = require('../models/message_system_model');

const connectedUsers = {};

const setupChatSocket = (server) => {
  const io = new Server(server);
  const chatNamespace = io.of('/chat');

  chatNamespace.on("connection", (socket) => {

    console.log("New client connected to chat namespace:", socket.id);

    socket.on("registerUser", (userId) => {

      connectedUsers[userId] = socket.id; 
      console.log(`User registered: ${userId} with socket ID: ${socket.id}`);
      console.log("Current connected users:", connectedUsers);
    });
    
    
    socket.on("sendMessage", async (messageData) => {
      const { sender, receiver, content } = messageData;

      try {
        const senderUser = await User.findOne({ school_id: sender });
        const receiverUser = await User.findOne({ school_id: receiver });
        
        if (senderUser && receiverUser) {
          const message = new Message({
            sender: senderUser._id,
            receiver: receiverUser._id,
            content,
          });
          await message.save(); // Save the message to the database

          // Check if the receiver is connected
          if (connectedUsers[receiver]) {
            // Emit the message to the connected receiver
            chatNamespace.to(connectedUsers[receiver]).emit("receiveMessage", {
              sender: senderUser.school_id,
              content: message.content,
              timestamp: message.createdAt,
            });
          } else {
            console.error(`Receiver ${receiver} is not connected.`);
            // Optionally handle undelivered messages (e.g., save to DB for later delivery)
          }
        } else {
          console.error("Sender or receiver not found");
        }
      } catch (error) {
        console.error("Error sending message:", error);
      }
    });

    // Handle disconnections
    socket.on("disconnect", () => {
      // Find and remove user from connectedUsers
      for (const userId in connectedUsers) {
        if (connectedUsers[userId] === socket.id) {
          delete connectedUsers[userId]; // Remove user from the list on disconnect
          console.log(`User disconnected: ${userId}`);
          break;
        }
      }
    });
  });
};

module.exports = setupChatSocket;
