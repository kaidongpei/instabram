var firebase = require('firebase-admin');
var request = require('request');

var API_KEY = "AAAAPl7vBe0:APA91bEMU9UvGhVJs1mKEWB7N3GEeNIA0F1S8-wc3z-Qg5Qfwk0tiUBueO9Ie9j02nicvQCMzpiGcv-Ge5tCsaybc_nWWSmvdrT3TtucfTWOQgvAqRfSVOWmQeGgmymuXip8iXZZj6rh";

var serviceAccount = require("./meta.json");

firebase.initializeApp({
	credential: firebase.credential.cert(serviceAccount),
	databaseURL: "https://instabramnf.firebaseio.com/"
});
ref = firebase.database().ref();

function listenForNotificationRequests() {
  var requests = ref.child('notificationRequests');
  requests.on('child_added', function(requestSnapshot) {
    var request = requestSnapshot.val();
      sendNotificationToUser(
      request.username, 
      request.message,
      request.sender,
      function() {
        requestSnapshot.ref.remove();
      }
    );
  }, function(error) {
    console.error(error);
  });
};

function sendNotificationToUser(username, message, sender, onSuccess) {
  request({
    url: 'https://fcm.googleapis.com/fcm/send',
    method: 'POST',
    headers: {
      'Content-Type' :' application/json',
      'Authorization': 'key='+API_KEY
    },
    body: JSON.stringify({
      notification: {
        title: "InstabramKD",
        text: message,
        sender: sender,
        username: username
      },
      to : "/topics/"+username
      //data: {rideInfo: rideinfo}
    })
  }, function(error, response, body) {
    if (error) { console.error(error); }
    else if (response.statusCode >= 400) { 
      console.error('HTTP Error: '+response.statusCode+' - '+response.statusMessage); 
    }
    else {
      onSuccess();
    }
  });
}

// start listening
listenForNotificationRequests();