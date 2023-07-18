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
  MyUser(DocumentSnapshot snapshot){
    // on récupère l'id du document
    id = snapshot.id;
    // on récupère les champs du document
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;

    // on récupère les champs et on les affecte aux variables
    email = map["email"];
    nom = map["nom"];
    prenom = map["prenom"];
    String? provisoirePseudo = map["pseudo"];
    favoris = map["favoris"] ?? [];

    if(provisoirePseudo == null){
      pseudo = "";
    } else {
      pseudo = provisoirePseudo;
    }

    birthday = map["birthday"] ?? DateTime.now();
    avatar = map["avatar"] ?? defaultImage;
  }

}