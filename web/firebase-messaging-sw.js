importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyCwkqiVyMvzqfSW1BMtIzPT9A4dK2VrR9g",
  authDomain: "universealert-1345f.firebaseapp.com",
  projectId: "universealert-1345f",
  storageBucket: "universealert-1345f.appspot.com",
  messagingSenderId: "1082954968772",
  appId: "1:1082954968772:web:c6822d69742edfbd47e391",
  measurementId: "G-R8LJ4J5MV8"
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});
