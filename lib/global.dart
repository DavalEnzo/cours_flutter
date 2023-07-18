import 'package:flutter/material.dart';

import 'model/my_user.dart';

enum Gender {
  homme,
  femme,
  transgenre,
  indefini
}

MyUser me = MyUser.empty();
String defaultImage = "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png";