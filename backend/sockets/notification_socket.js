const { Server } = require("socket.io");
const Notifications = require('../models/notifications_model');
const connectedUsers = require('./connected_users');


const setupNotificationSocket = (io) => {
  const notificationNamespace = io.of('/notifications');

  notificationNamespace.on("connection", (socket) => {
    console.log("New client connected to notifications namespace:", socket.id);

    socket.on("registerNotificationUser", (userId) => {
      connectedUsers[userId] = socket.id; 
      console.log(`User registered for notifications: ${userId} with socket ID: ${socket.id}`);
    });

    socket.on("receiveNotification", async (notificationData) => {
      const { sender, senderName, receiver, receiverName, role, title, message, scheduleId, date, time } = notificationData;
      
      const notification = new Notifications({
        sender,
        senderName,
        receiver,
        receiverName,
        role,
        title,
        message,
        scheduleId,
        date,
        time
      });

      try {
        await notification.save(); 
        console.log("Notification saved to database:");

        if (connectedUsers[receiver]) {
          notificationNamespace.to(connectedUsers[receiver]).emit("receiveNotification", { 
            title, 
            message 
          });
          console.log(`Notification sent to ${receiver}: ${message}`);
        } else {
          console.error(`Receiver ${receiver} is not connected to notifications.`);
        }
      } catch (error) {
        console.error("Error saving notification:", error);
      }
    });

    socket.on("disconnect", () => {
      for (const userId in connectedUsers) {
        if (connectedUsers[userId] === socket.id) {
          delete connectedUsers[userId]; 
          console.log(`User disconnected from notifications: ${userId}`);
          break;
        }
      }
    });
  });
};

module.exports = setupNotificationSocket;
