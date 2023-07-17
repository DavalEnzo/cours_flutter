// classe qui va nous aider à la gestion de la base de données

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreHelper{
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final cloudUsers = FirebaseFirestore.instance.collection("UTILISATEURS");

  // fonction pour créer un utilisateur
  register(String email, String password) async{
    UserCredential resultat = await auth.createUserWithEmailAndPassword(email: email, password: password);
    String uid = resultat.user?.uid ?? "";

    
  }

  // fonction pour se connecter

}