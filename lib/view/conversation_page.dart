import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cours_flutter/model/my_message.dart';
import 'package:cours_flutter/model/my_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConversationPage extends StatefulWidget {
  final MyUser user;

  const ConversationPage({Key? key, required this.user}) : super(key: key);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat avec ${widget.user.fullName}'),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('MESSAGERIE')
                  .where('conversationID', isEqualTo: FirebaseAuth.instance.currentUser!.uid.compareTo(widget.user.id) < 0
                  ? '${FirebaseAuth.instance.currentUser!.uid}_${widget.user.id}'
                  : '${widget.user.id}_${FirebaseAuth.instance.currentUser!.uid}')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    MyMessage message = MyMessage.fromDocument(document);
                    bool isSender = message.sender == FirebaseAuth.instance.currentUser!.uid;
                    return Container(
                      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: isSender ? Colors.blue[200] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(message.message, style: TextStyle(fontSize: 16, color: Colors.black)),
                            SizedBox(height: 5),
                            Text('From: ${message.sender}', style: TextStyle(fontSize: 13, color: Colors.grey)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Write a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      // Send the message to Firebase
                      FirebaseFirestore.instance.collection('MESSAGERIE').add({
                        'sender': FirebaseAuth.instance.currentUser!.uid,
                        'receiver': widget.user.id,
                        'message': _messageController.text,
                        'conversationID': FirebaseAuth.instance.currentUser!.uid.compareTo(widget.user.id) < 0
                            ? '${FirebaseAuth.instance.currentUser!.uid}_${widget.user.id}'
                            : '${widget.user.id}_${FirebaseAuth.instance.currentUser!.uid}',
                        'timestamp': Timestamp.now(),
                      });
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
