const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendPushNotification = functions.https.onCall(async (data, context) => {
  const { title, body, token } = data; // token = receiver’s FCM token

  const message = {
    notification: { title, body },
    token,
  };

  try {
    await admin.messaging().send(message);
    return { success: true };
  } catch (error) {
    console.error("Error sending message:", error);
    return { success: false, error: error.message };
  }
});
