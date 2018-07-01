var firebase = require("firebase/app");
require("firebase/database");
require("firebase/firestore");
firebase.initializeApp({
    apiKey: "AIzaSyBgI3dyFZk3VXcX514LmZ-3maife9GseHo",
    authDomain: "argue-chan.firebaseapp.com",
    databaseURL: "https://argue-chan.firebaseio.com",
    projectId: "argue-chan",
    storageBucket: "argue-chan.appspot.com"
 });
var firestore = firebase.firestore();
firestore.settings({
	timestampsInSnapshots: true 
});
var db = firebase.firestore();


// MAIN //


var app = { elm: null };
var posts = db.collection("post");
var threads = db.collection("thread");

app.elm = Elm.Main.init({
    flags: {
        seed: Math.floor(Math.random() * Number.MAX_SAFE_INTEGER),
        defaultName: localStorage.getItem("defaultName")
    }
});


// HELPERS //


function toElm (type, payload) {
	app.elm.ports.fromJs.send({
		type: type,
		payload: payload
	});
}


function receiveThread (thread) {
    toElm("received-thread", {
        id: thread.id,
        thread: thread.data()
    });
}


function getAllThreads(payload) {
    threads
        .where("boardId", "==", payload.boardId)
        .get()
        .then(function(threadsSnap) {
            var postIds = [];
            threadsSnap.forEach(function(thread) {
                receiveThread(thread);
            });
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


function submitNewPost(payload) {
    localStorage.setItem("defaultName", payload.author)

    var newPost = {
        author: payload.author,
        content: payload.content,
        createdAt: new Date().getTime()
    };

    var newThread;

    posts.doc(payload.postId).set(newPost)
    .then(function(){
        var thread = threads.doc(payload.threadId);
        thread.get().then(function(doc){
            var data = doc.data();

            var newThread = {
                title: data.title,
                posts: data.posts.concat([
                    payload.postId
                ]),
                createdAt: data.createdAt,
                boardId: data.boardId
            };

            thread.set(newThread)
            .then(function(){
                toElm("received-thread", {
                    id: payload.threadId,
                    thread: newThread
                });

                toElm("received-post", {
                    id: payload.postId,
                    post: newPost
                });
            });
        });
    });
}


function submitNewThread(payload) {
    localStorage.setItem("defaultName", payload.author)

    var now = new Date().getTime();

    var newThread = {
        title: payload.subject,
        posts: [ payload.postId ],
        createdAt: now,
        boardId: payload.boardId
    };

    var newPost = {
        author: payload.author,
        content: payload.content,
        createdAt: now
    }

    posts.doc(payload.postId).set(newPost)
    .then(function(){
        threads.doc(payload.threadId).set(newThread)
        .then(function(){
            toElm("received-thread", {
                id: payload.threadId,
                thread: newThread
            });

            toElm("received-post", {
                id: payload.postId,
                post: newPost
            });
        })
    });
}


// PORTS //


var actions = {
	getAllThreads,
    getPost,
    submitPassword,
    submitNewThread,
    submitNewPost,
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


// // INIT //


// function init() {
//     getAllThreads(); 
// }


// init();

