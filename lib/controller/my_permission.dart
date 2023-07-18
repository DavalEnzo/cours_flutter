import 'package:permission_handler/permission_handler.dart';

class MyPermissionPhoto{

  Future<PermissionStatus>init() async {
    PermissionStatus statuts = await Permission.photos.status;
    return checkPermission(statuts);
  }

  Future<PermissionStatus>checkPermission(PermissionStatus statuts) async {
    switch(statuts){
      case PermissionStatus.permanentlyDenied:
        return Future.error("Permission toujours refusée");
      case PermissionStatus.denied:
        return Permission.photos.request().then((value) => checkPermission(statuts));
      case PermissionStatus.provisional:
        return Permission.photos.request().then((value) => checkPermission(statuts));
      case PermissionStatus.restricted:
        return Permission.photos.request().then((value) => checkPermission(statuts));
      case PermissionStatus.limited:
        return Permission.photos.request().then((value) => checkPermission(statuts));
      case PermissionStatus.granted:
        return Permission.photos.request().then((value) => checkPermission(statuts));
    }
  }
}