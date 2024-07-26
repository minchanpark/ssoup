/*
울릉투어 맵에 연결된 맵 페이지
*/

import 'dart:async';
import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
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
  final Set<Polyline> _polylines = {};
  StreamSubscription<LocationData>? _locationSubscription;
  final List<LatLng> _trashLocation = [
    const LatLng(37.48647482397748, 130.9019350618274),
    const LatLng(37.45936612018906, 130.87541532279513),
    const LatLng(37.47034039061454, 130.88337429094736),
    const LatLng(37.48250373184974, 130.90788817561878),
  ];
  final LatLng _startLocation =
      const LatLng(37.47423184776412, 130.89445743384988);

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _fetchLocationsFromFirestore();
    _addStartLocationMarker(); // 추가된 시작 위치 마커를 생성하는 함수 호출
    _addTrashMarkers(); // 추가된 쓰레기통 마커를 생성하는 함수 호출
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

  void _addStartLocationMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('startLocation'),
          position: _startLocation,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: 'Start Location'),
        ),
      );
    });
  }

  void _addTrashMarkers() {
    setState(() {
      for (var location in _trashLocation) {
        _markers.add(
          Marker(
            markerId: MarkerId(location.toString()),
            position: location,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue), // 파란색 마커 설정
            infoWindow: const InfoWindow(title: 'Trash Bin'),
            onTap: () {
              _getNaverRoute(location);
            },
          ),
        );
      }
    });
  }

  Future<void> _getNaverRoute(LatLng destination) async {
    final String url =
        'https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving?start=${_startLocation.longitude},${_startLocation.latitude}&goal=${destination.longitude},${destination.latitude}&option=trafast';

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
        _calculateDistance(
          _startLocation.latitude,
          _startLocation.longitude,
          destination.latitude,
          destination.longitude,
        );
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
          color: Colors.blue,
          width: 5,
        ),
      );
    });
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Math.PI / 180
    const c = cos;
    final a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 *
        asin(sqrt(a)) *
        1000; // 2 * R; R = 6371 km, convert to meters
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
    const String style = '''[
    {
      "featureType": "all",
      "elementType": "labels",
      "stylers": [
        { "visibility": "on" }
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
        backgroundColor: const Color(0xffC6EBFE),
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
        polylines: _polylines,
      ),
    );
  }
}
