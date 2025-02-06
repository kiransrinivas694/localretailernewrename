import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:store_app_b2b/service/location_service_new.dart';

class MapController extends GetxController {
  bool isLoading = true;
  Map<String, dynamic> bodyMap = {};
  Position? position;
  final Set<Marker> markers = {};
  Placemark? address;

  Future<void> getCurrentLocation() async {
    isLoading = true;
    refresh();
    bool isAllowed = await LocationService.instance.checkLocationPermission();
    if (isAllowed) {
      if (bodyMap.isEmpty) {
        position = await LocationService.instance.getCurrentLocation();
        manageMarker(LatLng(position!.latitude, position!.longitude));
      } else {
        manageMarker(LatLng(double.parse(bodyMap['latitude']),
            double.parse(bodyMap['longitude'])));
      }
    } else {
      getCurrentLocation();
    }
    isLoading = false;
    refresh();
  }

  Future<void> manageMarker(LatLng argument) async {
    markers.clear();
    markers.add(
      Marker(
          markerId: const MarkerId('locationId'),
          icon: BitmapDescriptor.defaultMarker,
          position: argument),
    );
    refresh();
    List<Placemark> addresses =
        await placemarkFromCoordinates(argument.latitude, argument.longitude);
    address = addresses.first;
    refresh();
  }
}
