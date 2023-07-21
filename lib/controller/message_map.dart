import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cours_flutter/global.dart';
import 'package:flutter/material.dart';
import 'package:cours_flutter/controller/firestore_helper.dart';
import 'package:cours_flutter/model/my_user.dart';
import 'package:cours_flutter/view/conversation_page.dart'; // new import

class MessageMap extends StatefulWidget {
  const MessageMap({Key? key}) : super(key: key);

  @override
  _MessageMapState createState() => _MessageMapState();
}

class _MessageMapState extends State<MessageMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreHelper().cloudUsers.snapshots(),
        builder: (context, snap) {
          List documents = snap.data?.docs ?? [];
          return ListView.builder(
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
                      offset: Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatar!),
                  ),
                  title: Text(capitalize(user.fullName)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConversationPage(user: user),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.blueAccent,
      // ... your BottomNavigationBar code here ...
    );
  }
}
