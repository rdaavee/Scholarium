const admin = require("firebase-admin");
const service_account = require("./firebase-config.json");

admin.initializeApp({
  credential: admin.credential.cert(service_account),
  storageBucket: "ishkolarium-d31f1.appspot.com",  // Full Firebase storage bucket URL
});

const bucket = admin.storage().bucket();

module.exports = bucket;
    