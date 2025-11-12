import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapBackgroundPage extends StatefulWidget {
  const MapBackgroundPage({super.key});

  @override
  State<MapBackgroundPage> createState() => _MapBackgroundPageState();
}

class _MapBackgroundPageState extends State<MapBackgroundPage> {
  GoogleMapController? mapController;
  LatLng? currentLatLng;
  bool permissionGranted = false;


  Future<void> _checkPermissionAndFetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _showError('Location services are disabled.');
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await _showError('Location permissions are denied');
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await _showError(
          'Location permissions are permanently denied, cannot request.');
      return;
    }
    setState(() {
      permissionGranted = true;
    });
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLatLng = LatLng(position.latitude, position.longitude);
    });
  }
  @override
  void initState() {
    super.initState();
    _checkPermissionAndFetchLocation();
  }

  Future<void> _showError(String message) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Permission Error'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK'))
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !permissionGranted
          ? const Center(child: Text('Requesting location permission...'))
          : currentLatLng == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentLatLng!,
              zoom: 15,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) {
              mapController = controller;
            },
          ),


        ],
      ),
    );
  }
}
