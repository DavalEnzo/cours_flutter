import 'package:cloud_firestore/cloud_firestore.dart';

import '../global.dart';

class MyUser {
  late String id;
  late String email;
  late String nom;
  late String prenom;
  String? pseudo;
  DateTime? birthday;
  String? avatar;
  Gender genre = Gender.indefini;
  List? favoris;
  Map<String, dynamic>? coordonnees;

  String get fullName {
    return "$prenom $nom";
  }

  // constructeur
  MyUser.empty(){
    id = "";
    email = "";
    nom = "";
    prenom = "";
  }

  // constructeur bdd
  // on récupère le snapshot (document + champs) de l'utilisateur
  // ...rest of your MyUser code...

// constructeur bdd
// on récupère le snapshot (document + champs) de l'utilisateur
  MyUser(DocumentSnapshot snapshot) {
    // on récupère l'id du document
    id = snapshot.id;
    // on récupère les champs du document
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;

    // on récupère les champs et on les affecte aux variables
    email = map.containsKey('email') ? map['email'] : "";
    nom = map.containsKey('nom') ? map['nom'] : "";
    prenom = map.containsKey('prenom') ? map['prenom'] : "";
    pseudo = map.containsKey('pseudo') ? map['pseudo'] : "";
    favoris = map.containsKey('favoris') ? map['favoris'] : [];
    coordonnees = map.containsKey('coordonnees') ? map['coordonnees'] as Map<String, dynamic> : null;
    birthday = map.containsKey('birthday') ? map['birthday'].toDate() : DateTime.now();
    avatar = map.containsKey('avatar') ? map['avatar'] : defaultImage;
  }

// ...rest of your MyUser code...


}