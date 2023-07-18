// classe qui va nous aider à la gestion de la base de données

import 'package:cours_flutter/model/my_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreHelper{
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final cloudUsers = FirebaseFirestore.instance.collection("UTILISATEURS");

  // fonction pour créer un utilisateur
  // Future sert à récupérer des erreurs en cas de problème (sorte de try catch)
  Future <MyUser> register(String email, String password, String nom, String prenom) async{
    UserCredential resultat = await auth.createUserWithEmailAndPassword(email: email, password: password);

    String uid = resultat.user?.uid ?? "";
    Map<String, dynamic> map = {
      "email": email,
      "nom": nom,
      "prenom": prenom,
    };

    addUser(uid, map);

    return getUser(uid);
  }

  // Future sert à récupérer des erreurs en cas de problème (sorte de try catch)
  Future<MyUser>getUser(String uid) async {
    DocumentSnapshot snapshot = await cloudUsers.doc(uid).get();
    return MyUser(snapshot);
  }

  addUser(String uid, Map<String, dynamic> data) async{
    await cloudUsers.doc(uid).set(data);
  }

  // fonction pour se connecter
  // Future sert à récupérer des erreurs en cas de problème (sorte de try catch)
  Future<MyUser> connect(String email, String password) async{
    UserCredential resultat = await auth.signInWithEmailAndPassword(email: email, password: password);

    String uid = resultat.user?.uid ?? "";

    return getUser(uid);
  }

}