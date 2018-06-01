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


var app = { elm: null };
app.elm = Elm.Main.fullscreen();

threads.get().then(function(threadsSnap) {
    var postIds = [];
    threadsSnap.forEach(function(thread) {
        sendThread(thread);
        postIds = postIds.concat(thread.data().posts);
    });

    posts.get(postIds).then(function(postsSnap) {
        postsSnap.forEach(sendPost);
    });
});


function toElm (type, payload) {
	app.elm.ports.fromJs.send({
		type: type,
		payload: payload
	});
}

function sendThread (thread) {
    toElm("received-thread", {
        id: thread.id,
        posts: thread.data().posts
    });
}

function getAllThreads() {
	threads.get().then(function(snap) {
		snap.forEach(sendThread);
	});
}

function sendPost (post) {
    toElm("received-post", {
        id: post.id,
        post: post.data()
    });
}

function getPost(payload) {
    posts.get(payload).then(function(snap) {
        snap.forEach(sendPost);
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

app.elm.ports.toJs.subscribe(jsMsgHandler);