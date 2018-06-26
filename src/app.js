var firebase = require("firebase/app");
require("firebase/database");
require("firebase/firestore");
var apiKey = localStorage.getItem("firebase-apikey");
var config = {
    // apiKey: "AIzaSyBgI3dyFZk3VXcX514LmZ-3maife9GseHo",
    apiKey: apiKey,
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

app.elm = Elm.Main.init({
    flags: {
        apiKey: Boolean(apiKey),
        seed: Math.floor(Math.random() * Number.MAX_SAFE_INTEGER) 
    }
});

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
        title: thread.data().title,
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

function submitPassword(payload) {
    localStorage.setItem("firebase-apikey", payload);
    window.location.reload();
}

// // Add a new document in collection "cities"
// db.collection("cities").doc("LA").set({
//     name: "Los Angeles",
//     state: "CA",
//     country: "USA"
// })
// .then(function() {
//     console.log("Document successfully written!");
// })
// .catch(function(error) {
//     console.error("Error writing document: ", error);
// });


function submitNewThread(payload) {
    posts.doc(payload.postId).set({
        author: payload.author,
        content: payload.content
    }).then(function(){
        threads.doc(payload.threadId).set({
            title: payload.subject,
            posts: [ payload.postId ]
        }).then(function(){
            console.log('thread r')
        })
        console.log("Response", r);
    });
}

var actions = {
	getAllThreads,
    getPost,
    submitPassword,
    submitNewThread,
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