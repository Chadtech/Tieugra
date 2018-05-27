var firebase = require("firebase/app");
require("firebase/database");
require("firebase/firestore");
var config = {
    apiKey: "AIzaSyBgI3dyFZk3VXcX514LmZ-3maife9GseHo",
    authDomain: "argue-chan.firebaseapp.com",
    databaseURL: "https://argue-chan.firebaseio.com",
    projectId: "argue-chan",
    storageBucket: "argue-chan.appspot.com",
    messagingSenderId: "151287390405"
 };
firebase.initializeApp(config);
var firestore = firebase.firestore();
firestore.settings({
	timestampsInSnapshots: true 
});
var db = firebase.firestore();
var posts = db.collection("post");
var threads = db.collection("thread");


var app = Elm.Main.fullscreen();

function toElm (type, payload) {
	app.ports.fromJs.send({
		type: type,
		payload: payload
	});
}

function getAllThreads() {
	threads.get().then(function(snap) {
		snap.forEach(function(thread) {
			toElm("received-all-threads", { 
				id: thread.id,
				posts: thread.data().posts
			});
		});
	});
}

function getPost(payload) {
    posts.get(payload).then(function(snap) {
        snap.forEach(function(post) {
            toElm("received-post", {
                id: post.id,
                post: post.data()
            });
        });
    });
}

var actions = {
	getAllThreads,
    getPost
};

function jsMsgHandler(msg) {
	var action = actions[msg.type];
	if (typeof action === "undefined") {
		console.log("Unrecognized js msg type ->", msg.type);
		return;
	}
	action(msg.payload);
}

app.ports.toJs.subscribe(jsMsgHandler);