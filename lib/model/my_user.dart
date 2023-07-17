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

  // constructeur
  MyUser(){
    id = "";
    email = "";
    nom = "";
    prenom = "";

  }

}