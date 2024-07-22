import 'dart:async';
import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:ssoup/constants.dart';
import 'package:ssoup/theme/text.dart';

class BigMapPage extends StatefulWidget {
  const BigMapPage({super.key});

  @override
  State<BigMapPage> createState() => _BigMapPageState();
}

class _BigMapPageState extends State<BigMapPage> {
  GoogleMapController? _mapController;
  LatLng _ulleungDo = const LatLng(37.49893355978079, 130.86866855621338);
  final Location _location = Location();
  final Set<Marker> _markers = {};
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _fetchLocationsFromFirestore();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final currentLocation = await _location.getLocation();
    if (!mounted) return;
    setState(() {
      _ulleungDo =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
      _updateCurrentLocationMarker();
      _mapController?.animateCamera(CameraUpdate.newLatLng(_ulleungDo));
    });

    _locationSubscription =
        _location.onLocationChanged.listen((LocationData currentLocation) {
      if (!mounted) return;
      setState(() {
        _ulleungDo =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _updateCurrentLocationMarker();
        _mapController?.animateCamera(CameraUpdate.newLatLng(_ulleungDo));
      });
    });
  }

  void _updateCurrentLocationMarker() {
    if (!mounted) return;
    setState(() {
      _markers.removeWhere((marker) => marker.markerId == const MarkerId('cL'));
      _markers.add(
        Marker(
          markerId: const MarkerId('cL'),
          position: _ulleungDo,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Current Location'),
        ),
      );
    });
  }

  Future<void> _fetchLocationsFromFirestore() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('locationMap').get();

    setState(() {
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final LatLng location =
            LatLng(data['location'][0], data['location'][1]);
        final String name = data['locationName'];
        final String information = data['information'];

        _markers.add(
          Marker(
            markerId: MarkerId(doc.id),
            position: location,
            onTap: () {
              _showMarkerInfoDialog(name, information);
            },
          ),
        );
      }
    });
  }

  void _showMarkerInfoDialog(String name, String information) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(name),
          content: Text(information),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _setMapStyle(GoogleMapController controller) async {
    final String style = '''[
    {
      "featureType": "all",
      "elementType": "labels",
      "stylers": [
        { "visibility": "off" }
      ]
    },
    {
      "featureType": "landscape",
      "elementType": "geometry",
      "stylers": [
        { "color": "#ffffff" }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        { "color": "#C6EBFE" }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
        { "visibility": "simplified" },
        { "color": "#cccccc" }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "geometry",
      "stylers": [
        { "color": "#ffffff" }
      ]
    }
  ]''';
    controller.setMapStyle(style);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '울릉투어 맵',
          style: regular23,
        ),
        backgroundColor: Color(0xffC6EBFE),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _ulleungDo,
          zoom: 11.8,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          _setMapStyle(controller);
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
