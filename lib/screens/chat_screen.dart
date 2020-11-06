import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:abhishek_chat_app/constants.dart';

final _firestore = FirebaseFirestore
    .instance; //declared here to be available to the whole file as we have moved StreamBuilder
//from the state widget to seperate widget
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int counter = 0;
  final _auth = FirebaseAuth.instance;
  //FirebaseUser user;//As it is depricated
  //final _firestore = FirebaseFirestore.instance;
  // Firestore.instance; - depricated

  String messageText;
  final _messageTextController = TextEditingController();
  bool _isMe;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    //Auth will have current user information if it has been logged in or signed in
    //And it gives a future
    try {
      /* Old Way
      final user = await _auth.currentUser;
      print(user.runtimeType);
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
      
      */
      _auth.authStateChanges().listen((user) {
        if (user != null) {
          loggedInUser = user;
        } else {
          print('user is not currently logged in');
        }
      });
    } catch (e) {
      print(e);
    }
    print("loggedInUser : $loggedInUser");
  }

/*
  void getMessages() async{
    final messages = await _firestore.collection('messages').get();//earlier getDocuments();
    //.get() returns a future of QuerySnapshots
    for(var message in messages.docs){//earlier .documents returns List<DocumentSnapshots>
    //but docs returns a List<QueryDocumentSnapshots>
    print(message.data);

    }
  }
  But this is one time thus it won't tell when the change occurs
*/

  void messageStream() async {
    //:::final messages = await _firestore.collection('messages').snapshots();
    //snapshots returns a Stream<QuerySnapshots> & Notifies of query when there is CRUD on database
    //it is list of future objects

    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message
            .data); //this will re run whole of the method and print all the documents as we are registered to it
      }
    }
  }

  /*Stream - it is a plural or Future
  just like plural of an object like String is List<String>
  Thus plural of Future<String> will be Stream<String>

  Thus Stream will provide a list of Future which means each data will be associated with a Future
  and it can come at any time
  So When it comes it doesn't loads all of the previous data from scratch rather gives only the current one

  Widget - StreamBuilder()  it will run setStates whenever new data comes asynchronously
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                print('Auth RuntimeType ${_auth.runtimeType}');
                _auth.signOut();
                Navigator.pop(
                    context); //to remove the screen from the screen context
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      _messageTextController.clear();
                      //Implement send functionality.
                      await _firestore.collection('messages').add({
                        //.collection() is referring to the name of the collection
                        //.add() accepts a Map<String, dynamic> where key=String and value=
                        'text': messageText,
                        'sender': loggedInUser.email
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .snapshots(), //this tells the source of the Stream
      //builder: ,//it is the buildStrategy i.e. the logic and tell what we want to do with the stream
      //Whenever some data is changed online stream builder receives a snapshot thus builder will rebuild all the children of StreamBuilder
      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
        //this snapshot is different from firestore snapshot
        // & builder returns a Widget

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        //print('StreamBuilder called ${++counter}');
        // List<Text> messageList = [];
        List<MessageBubble> messageList = [];

        final messages = snapshot.data.docs.reversed;
        //snapshot here is the snapshot of AsyncSnapshot thus it is dynamic
        //to be specific we must tell after the StreamBuilder what kind of snapshot it will have
        //The snapshot we want is the QuerySnapshot

        print('Messages Type: ${messages.runtimeType}');
        for (var message in messages) {
          //print('Inside For called ${counter}');
          print('Message ::: Type ${message.runtimeType}');
          print('Message Data ::: Type ${message.data.runtimeType}');
          String text = message.get('text');
          String sender = message.get('sender');

          final currentUser = loggedInUser.email;

          if (currentUser == sender) {
            //since sender is an email
          }
          final messageWidget =
              MessageBubble(text, sender, currentUser == sender);
          messageList.add(messageWidget);
        }
        // messages.forEach((message){
        //   print('Message ::: Type ${message.runtimeType}');
        //   print('Message Data ::: Type ${message.data.runtimeType}');
        //   String text = message.data['text'];
        //   String sender = message.data['sender'];
        //   final messageWidget = Text('$text @$sender');
        //   messageList.add(messageWidget);

        // });

        //return Column(children: messageList,);
        //instead of returning a Column return as ListView because it have a scrolling feature
        return Expanded(
          child: ListView(
            reverse: true,//inorder to display the last added message first
            //also we need to reverse the list of documents in snapshot of firebase
            //this will show the bottom  of the list view
            children: messageList,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  MessageBubble(this.text, this.sender, this.isMe);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        //this Column is just a Message bubble not whole list of messages
        //Thus we can also align is according to the user sending message
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
              // borderRadius: BorderRadius.circular(30.0),
              //to make pointing border
              borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(30.0), bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0))
                                : BorderRadius.only(topRight: Radius.circular(30.0), bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0)),
              elevation: 5.0,
              color: isMe ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: isMe ? Colors.white : Colors.black54,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

//with material widget we can specify background color
