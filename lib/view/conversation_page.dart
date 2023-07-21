import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cours_flutter/view/user_details.dart';
import 'package:flutter/material.dart';
import 'package:cours_flutter/model/my_message.dart';
import 'package:cours_flutter/model/my_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../global.dart';

class ConversationPage extends StatefulWidget {
  final MyUser user;

  const ConversationPage({Key? key, required this.user}) : super(key: key);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.65,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetails(userId: widget.user.id)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.user.avatar ?? ''),
                ),
                const SizedBox(width: 15),
                Text(capitalize(widget.user.fullName)),
              ],
            ),
          ),
        ),
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
                  return const Text('Quelque chose s\'est mal passé');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        backgroundColor: Colors.deepOrange,
                        strokeWidth: 7,
                      ),
                    ),
                  );
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                });

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    MyMessage message = MyMessage.fromDocument(document);
                    bool isSender = message.sender == FirebaseAuth.instance.currentUser!.uid;
                    return Container(
                      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: isSender ? Colors.blue[200] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(message.message, style: const TextStyle(fontSize: 16, color: Colors.black)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
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
      backgroundColor: Colors.white,
    );
  }
}
