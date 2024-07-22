import 'dart:async';
import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'package:ssoup/constants.dart';

class BigMapPage extends StatefulWidget {
  const BigMapPage({super.key});

  @override
  State<BigMapPage> createState() => _BigMapPageState();
}

class _BigMapPageState extends State<BigMapPage> {
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(37.49893355978079, 130.86866855621338);
  final Location _location = Location();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _addMarkers();
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
      _currentPosition =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
      _updateCurrentLocationMarker();
      _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition));
    });

    _locationSubscription =
        _location.onLocationChanged.listen((LocationData currentLocation) {
      if (!mounted) return;
      setState(() {
        _currentPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _updateCurrentLocationMarker();
        _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition));
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
          position: _currentPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Current Location'),
        ),
      );
    });
  }

  void _addMarkers() {
    const LatLng nariBunji = LatLng(37.5121, 130.8755);
    const LatLng dokdoObservatory = LatLng(37.4864, 130.9262);
    const LatLng bongnaeWaterfall = LatLng(37.4983781, 130.8833256);
    const LatLng mushrRock = LatLng(37.486811659680065, 130.80605506896973);

    setState(() {
      _markers.addAll([
        Marker(
          markerId: MarkerId('NariBunji'),
          position: nariBunji,
          infoWindow: InfoWindow(title: '나리분지'),
        ),
        Marker(
          markerId: MarkerId('DokdoObservatory'),
          position: dokdoObservatory,
          infoWindow: InfoWindow(title: '독도 전망대'),
        ),
        Marker(
          markerId: MarkerId('BongnaeWaterfall'),
          position: bongnaeWaterfall,
          infoWindow: InfoWindow(title: '봉래폭포'),
        ),
        Marker(
          markerId: MarkerId('TurtleRock'),
          position: mushrRock,
          infoWindow: InfoWindow(title: '버섯바위'),
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map Page'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 11.8,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        polylines: _polylines,
      ),
    );
  }
}
