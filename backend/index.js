//imports
require("dotenv").config();
const connectDB = require('./db');
const cors = require("cors");
const express = require("express");
const bodyParser = require("body-parser");
const userRoutes = require("./routers/user_routes");
const professorRoutes = require("./routers/professor_routes");
const adminRoutes = require("./routers/admin_routes");
const loginRoutes = require("./routers/login_routes");
const path = require("path");
const app = express();
const PORT = process.env.PORT || 3000;

connectDB();
app.use(cors());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// Use routes
app.use("/api", userRoutes);
app.use("/api", professorRoutes);
app.use("/api", adminRoutes);
app.use("/api", loginRoutes);

app.use("/uploads", express.static(path.join(__dirname, "uploads")));

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server is running on port ${PORT}`);
});
