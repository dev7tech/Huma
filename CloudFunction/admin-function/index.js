const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationToAllUsers = functions.https.onCall(async (data, context) => {
 console.info(data["message"])
 
  

  try {
    const usersSnapshot = await admin.firestore().collection('Users').get();

    const tokens = [];
    usersSnapshot.forEach((userDoc) => {
      const userPushToken = userDoc.data().pushToken;
      if (userPushToken) {
        tokens.push(userPushToken);
      }
    });

    

    const payload = {
      notification: {
        title: data['title'],
        body: data['message'],
          badge: '1',
          sound: 'default'
      }
  }

    await admin.messaging().sendToDevice(tokens, payload);
   
  } catch (error) {
    console.error('Error sending notification:', error);
  
  }
}
);


