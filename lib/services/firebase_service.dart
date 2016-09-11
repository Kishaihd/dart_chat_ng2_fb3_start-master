import 'dart:html';
import 'dart:async';

import 'package:angular2/core.dart';
import 'package:firebase3/firebase.dart' as fb;
import '../models/message.dart';


@Injectable()
class FirebaseService {
  //int NUM_LAST_MESSAGES = 12;

  fb.Auth _fbAuth;
  fb.GoogleAuthProvider _fbGoogleAuthProvider;
  fb.Database _fbDatabase;
  fb.Storage _fbStorage;
  fb.DatabaseReference _fbRefMessages;

  fb.User user;

  List<Message> messages;

  FirebaseService() {
    fb.initializeApp(
        apiKey: "AIzaSyD0DwFyEAbJzWfgSbFMTNx2ZF__PaaW_5o",
        authDomain: "chatproject-5f828.firebaseapp.com",
        databaseURL: "https://chatproject-5f828.firebaseio.com",
        storageBucket: "chatproject-5f828.appspot.com"
    );

    _fbGoogleAuthProvider = new fb.GoogleAuthProvider();
    _fbAuth = fb.auth();
    _fbAuth.onAuthStateChanged.listen(_authChanged);

    _fbDatabase = fb.database();
    _fbRefMessages = _fbDatabase.ref("messages");

  }

  void _authChanged(fb.AuthEvent event) {
    user = event.user;

    if (user != null) {
      messages = [];
      //_fbRefMessages.limitToLast(NUM_LAST_MESSAGES).onChildAdded.listen(_newMessage);
      _fbRefMessages.limitToLast(12).onChildAdded.listen(_newMessage);
    }


  }

  Future signIn() async {
    try {
      await _fbAuth.signInWithPopup(_fbGoogleAuthProvider);
    }
    catch (error) {
      print("$runtimeType::login() -- $error");
    }
  }

  void signOut() {
    _fbAuth.signOut();
  }

  void _newMessage(fb.QueryEvent event) {
    Message msg = new Message.fromMap(event.snapshot.val());
    messages.add(msg);

    print(msg.text);
  }

  Future sendMessage({String text, String imageURL}) async {
    try {
      Message msg = new Message(user.displayName, text, user.photoURL, imageURL);
      await _fbRefMessages.push(msg.toMap());
    }
    catch (error) {
      print("$runtimeType::sendMessage() -- $error");
    }
  }
}