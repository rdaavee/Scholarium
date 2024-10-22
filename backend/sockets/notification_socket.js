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
      console.log("trying to receive");
      console.log('Received notification data:', notificationData);
      
      const { sender, senderName, receiver, receiverName, role, title, message, scheduleId, date, time } = notificationData;
    
      try {
        if (connectedUsers[receiver]) {
          console.log(`Sending notification to: ${receiver}`);
          notificationNamespace.to(connectedUsers[receiver]).emit("receiveNotification", { 
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
          console.log(`Notification sent to ${receiver}: ${message}`);
        } else {
          console.error(`Receiver ${receiver} is not connected to notifications.`);
        }
      } catch (error) {
        console.error("Error processing notification:", error);
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
