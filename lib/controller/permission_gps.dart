import 'package:geolocator/geolocator.dart';

class PermissionGps{
  Future <Position>init() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Impossible de localiser l\'appareil: Service GPS désactivé');
    } else {
      LocationPermission permission = await Geolocator.checkPermission();
      return checkPermission(permission);
    }
  }

  Future<Position> checkPermission(LocationPermission permission) {
    switch(permission){
      case LocationPermission.denied: return Geolocator.requestPermission().then((value) => checkPermission(value));
      case LocationPermission.deniedForever: return Future.error('Ne souhaite pas donner ses informations de localisation');
      case LocationPermission.unableToDetermine: return Geolocator.requestPermission().then((value) => checkPermission(value));
      case LocationPermission.whileInUse: return Geolocator.getCurrentPosition();
      case LocationPermission.always: return Geolocator.getCurrentPosition();
      default: return Future.error('Erreur inconnue');
    }
  }
}