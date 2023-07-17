// classe qui va nous aider à la gestion de la base de données

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreHelper{
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final cloudUsers = FirebaseFirestore.instance.collection("UTILISATEURS");

  // fonction pour créer un utilisateur
  register(String email, String password, String nom, String prenom) async{
    UserCredential resultat = await auth.createUserWithEmailAndPassword(email: email, password: password);

    String uid = resultat.user?.uid ?? "";
    Map<String, dynamic> map = {
      "email": email,
      "nom": nom,
      "prenom": prenom,
    };

    addUser(uid, map);

  }

  addUser(String uid, Map<String, dynamic> data) async{
    await cloudUsers.doc(uid).set(data);
  }

  // fonction pour se connecter

}