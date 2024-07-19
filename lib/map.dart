import 'dart:async';
import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:ssoup/constants.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(36.10155104193711, 129.39063285108818);
  final Location _location = Location();
  final Set<Marker> _markers = {};
  final LatLng _destinationLocation = const LatLng(36.1022665, 129.3913618);
  final LatLng _startLocation = const LatLng(36.1047753, 129.3876298);
  final Set<Polyline> _polylines = {};
  StreamSubscription<LocationData>? _locationSubscription;

  Future<void> _getNaverRoute() async {
    final String url =
        'https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving?start=${_startLocation.longitude},${_startLocation.latitude}&goal=${_destinationLocation.longitude},${_destinationLocation.latitude}&option=trafast';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'X-NCP-APIGW-API-KEY-ID': naverClientId,
        'X-NCP-APIGW-API-KEY': naverClientSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Response Data: $data');

      final List<dynamic>? routes = data['route'] != null
          ? data['route']['trafast'] ?? data['route']['traoptimal']
          : null;

      if (routes != null && routes.isNotEmpty) {
        final points = routes[0]['path'];
        _setPolylineFromNaverPoints(points);
      } else {
        print('No routes found');
      }
    } else {
      print('Failed to load directions: ${response.statusCode}');
      print('Error Response: ${response.body}');
    }
  }

  void _setPolylineFromNaverPoints(List points) {
    final List<LatLng> polylineCoordinates = points.map<LatLng>((point) {
      return LatLng(point[1], point[0]);
    }).toList();

    if (!mounted) return;
    setState(() {
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: polylineCoordinates,
          color: Colors.black,
          width: 5,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _setInitialMarkers();
    _getNaverRoute();
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

        double distance = _calculateDistance(
          _currentPosition.latitude,
          _currentPosition.longitude,
          _destinationLocation.latitude,
          _destinationLocation.longitude,
        );

        if (distance <= 10) {
          _showArrivalPopup(context);
        }
      });
    });
  }

  Future<Map<String, dynamic>> _fetchNotificationData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .doc('destinationArrival')
        .get();
    return snapshot.data() as Map<String, dynamic>;
  }

  void _showArrivalPopup(BuildContext context) async {
    Map<String, dynamic> notificationData = await _fetchNotificationData();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(notificationData['title']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.network(notificationData['imageUrl']),
              Text(notificationData['content']),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  double _calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void _setInitialMarkers() {
    _markers.add(Marker(
      markerId: const MarkerId('start'),
      position: _startLocation,
      infoWindow: const InfoWindow(title: '출발지'),
    ));
    _markers.add(Marker(
      markerId: const MarkerId('destination'),
      position: _destinationLocation,
      infoWindow: const InfoWindow(title: '도착지'),
    ));
  }

  void _updateCurrentLocationMarker() {
    _markers.removeWhere((m) => m.markerId == const MarkerId('current'));
    _markers.add(Marker(
      markerId: const MarkerId('current'),
      position: _currentPosition,
      infoWindow: const InfoWindow(title: '현재 위치'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 15.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        markers: _markers,
        polylines: _polylines,
      ),
    );
  }
}
