import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapTabProvider extends ChangeNotifier {
  MapTabProvider() {
    log('Provider Created');

    getUserLocation();
  }

  final Location location = Location();
  final Set<Marker> markers = {};

  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 17,
  );

  Future<bool> _getLocationPermission() async {
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
    }
    return permissionStatus == PermissionStatus.granted;
  }

  Future<bool> _checkLocationService() async {
    bool isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
    }
    return isServiceEnabled;
  }

  Future<void> _changeCameraPosition(LocationData locationData) async {
    cameraPosition = CameraPosition(
      target: LatLng(locationData.latitude, locationData.longitude),
      zoom: 17,
    );

    markers.add(
      Marker(
        markerId: const MarkerId('1'),
        position: LatLng(locationData.latitude, locationData.longitude),
        infoWindow: const InfoWindow(title: 'Your location'),
      ),
    );

    final GoogleMapController controller = await mapController.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    notifyListeners();
  }

  Future<void> getUserLocation() async {
    bool isPermissionGranted = await _getLocationPermission();
    if (!isPermissionGranted) return;

    bool isLocationServiceEnabled = await _checkLocationService();
    if (!isLocationServiceEnabled) return;

    LocationData locationData = await location.getLocation();

    await _changeCameraPosition(locationData);
  }

  @override
  void dispose() {
    log('Provider Disposed');
    super.dispose();
  }
}
