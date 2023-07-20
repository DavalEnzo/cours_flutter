import 'package:cloud_firestore/cloud_firestore.dart';

class MyMessage {
  final String id;
  final String sender;
  final String receiver;

  MyMessage({required this.id, required this.sender, required this.receiver});

  // Méthode pour convertir un DocumentSnapshot en une instance de MyMessage
  factory MyMessage.fromDocument(DocumentSnapshot doc) {
    return MyMessage(
      id: doc.id,
      sender: doc['sender'],
      receiver: doc['receiver'],
    );
  }

  // Méthode pour convertir une instance de MyMessage en un Map pour Firebase
  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'receiver': receiver,
    };
  }
}
