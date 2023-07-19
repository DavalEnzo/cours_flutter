import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';

import 'dart:io';


import 'model/my_user.dart';

enum Gender {
  homme,
  femme,
  transgenre,
  indefini
}

MyUser me = MyUser.empty();
String defaultImage = "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png";

// fonction qui fait un popup d'erreur en fonction de la plateforme
MyPopupError(dynamic erreur, String typeErreur, String message, BuildContext context){
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context){
        if(Platform.isIOS){
          return CupertinoAlertDialog(
            title: Text(typeErreur),
            content: Text("$message: $erreur"),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              )
            ],
          );
        } else {
          return AlertDialog(
            title: Text(typeErreur),
            content: Text("$message: $erreur"),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              )
            ],
          );
        }
      }
  );
}