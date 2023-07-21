import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cours_flutter/model/my_message.dart';
import 'package:cours_flutter/controller/firestore_helper.dart';
import 'package:cours_flutter/model/my_user.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MessageMap extends StatefulWidget {
  const MessageMap({Key? key}) : super(key: key);

  @override
  _MessageMapState createState() => _MessageMapState();
}

class _MessageMapState extends State<MessageMap> {
  final TextEditingController _messageController = TextEditingController();
  MyUser? selectedUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedUser != null ? 'Chat avec ${selectedUser!.fullName}' : ''),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirestoreHelper().cloudUsers.snapshots(),
            builder: (context, snap) {
              List documents = snap.data?.docs ?? [];
              return Expanded(
                child: ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    MyUser user = MyUser(documents[index]);
                    return Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: ListTile(
                        title: Text(user.fullName),
                        onTap: () {
                          setState(() {
                            selectedUser = user;
                          });
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
          if (selectedUser != null) ...[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('MESSAGERIE')
                    .where('conversationID', isEqualTo: FirebaseAuth.instance.currentUser!.uid.compareTo(selectedUser!.id) < 0
                    ? '${FirebaseAuth.instance.currentUser!.uid}_${selectedUser!.id}'
                    : '${selectedUser!.id}_${FirebaseAuth.instance.currentUser!.uid}')
                    .orderBy('timestamp', descending: false) // Sorting by timestamp
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
                      return ListTile(
                        title: Text(message.message),
                        subtitle: Text('From: ${message.sender}'),
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
                          'receiver': selectedUser!.id,
                          'message': _messageController.text,
                          'conversationID': FirebaseAuth.instance.currentUser!.uid.compareTo(selectedUser!.id) < 0
                              ? '${FirebaseAuth.instance.currentUser!.uid}_${selectedUser!.id}'
                              : '${selectedUser!.id}_${FirebaseAuth.instance.currentUser!.uid}',
                          'timestamp': Timestamp.now(), // Adding timestamp
                        });
                        _messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          unselectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              label: "Upload",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Likes",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "Account",
            ),
          ],
        ),
      ),
    );
  }
}
