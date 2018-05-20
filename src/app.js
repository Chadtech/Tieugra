var firebase = require("firebase/app");
require("firebase/database");
var config = {
	apiKey: "AIzaSyBgI3dyFZk3VXcX514LmZ-3maife9GseHo",
	authDomain: "argue-chan.firebaseapp.com",
	databaseURL: "https://argue-chan.firebaseio.com",
	projectId: "argue-chan",
	storageBucket: "",
	messagingSenderId: "151287390405"
};
firebase.initializeApp(config);

var app = Elm.Main.fullscreen();
console.log(app)

function toElm (type, payload) {
	app.ports.fromJs.send({
		type: type,
		payload: payload
	});
}

function square(n) {
	toElm("square computed", n * n);
}

var actions = {
	consoleLog: console.log,
	square: square
}

function jsMsgHandler(msg) {
	var action = actions[msg.type];
	if (typeof action === "undefined") {
		console.log("Unrecognized js msg type ->", msg.type);
		return;
	}
	action(msg.payload);
}
console.log(app);
// app.ports.toJs.subscribe(jsMsgHandler)

