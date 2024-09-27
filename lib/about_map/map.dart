//관광지 길 안내를 위한 페이지

import 'dart:async';
import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ssoup/constants.dart';

class GoogleMapPage extends StatefulWidget {
  final List startLocation;
  final List endLocation;
  final List location1;
  final List location2;

  const GoogleMapPage({
    super.key,
    required this.startLocation,
    required this.endLocation,
    required this.location1,
    required this.location2,
  });

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  GoogleMapController? _mapController;
  late LatLng _currentPosition;
  final Set<Marker> _markers = {};
  late LatLng _destinationLocation;
  late LatLng _startLocation;
  final Set<Polyline> _polylines = {};
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _initializeLocations();
    _checkPermissions();
    _addInitialMarkers();
    _addLocationMarkers();
    _getNaverRoute();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  // 위치 초기화
  void _initializeLocations() {
    _startLocation = LatLng(widget.startLocation[0], widget.startLocation[1]);
    _destinationLocation = LatLng(widget.endLocation[0], widget.endLocation[1]);
    _currentPosition = _startLocation;
  }

  // 권한 확인 및 현재 위치 설정
  Future<void> _checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) return;
    }

    final currentPosition = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition =
          LatLng(currentPosition.latitude, currentPosition.longitude);
      _updateCurrentLocationMarker();
    });

    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _updateCurrentLocationMarker();

        if (_calculateDistance(
              _currentPosition.latitude,
              _currentPosition.longitude,
              _destinationLocation.latitude,
              _destinationLocation.longitude,
            ) <=
            30) {
          _showArrivalPopup(context, _destinationLocation, _startLocation);
        }
      });
    });
  }

  // 현재 위치 마커 업데이트
  void _updateCurrentLocationMarker() {
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

  // 초기 마커 추가 (출발지 및 도착지)
  void _addInitialMarkers() {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('sL'),
          position: _startLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Start Location'),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('dL'),
          position: _destinationLocation,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: 'Destination Location'),
        ),
      );
    });
  }

  // 추가적인 위치 마커 설정 (location1, location2)
  void _addLocationMarkers() {
    LatLng location1 = LatLng(widget.location1[0], widget.location1[1]);
    LatLng location2 = LatLng(widget.location2[0], widget.location2[1]);

    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('location1'),
          position: location1,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Location 1'),
          onTap: () => _setNaverRoute(location1),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('location2'),
          position: location2,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Location 2'),
          onTap: () => _setNaverRoute(location2),
        ),
      );
    });
  }

  // Naver API를 사용하여 경로를 가져오고 폴리라인을 설정
  Future<void> _setNaverRoute(LatLng destination) async {
    try {
      final currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng currentLatLng =
          LatLng(currentPosition.latitude, currentPosition.longitude);

      final url =
          'https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving?start=${currentLatLng.longitude},${currentLatLng.latitude}&goal=${destination.longitude},${destination.latitude}&option=trafast';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'X-NCP-APIGW-API-KEY-ID': naverClientId,
          'X-NCP-APIGW-API-KEY': naverClientSecret,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final points = data['route']?['trafast']?.first['path'] ?? [];

        if (points.isNotEmpty) {
          _setPolylineFromNaverPoints(points);
        }
      } else {
        print('Failed to load directions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getting route: $e');
    }
  }

  // 경로 데이터를 이용해 폴리라인을 지도에 추가
  void _setPolylineFromNaverPoints(List points) {
    final List<LatLng> polylineCoordinates = points.map<LatLng>((point) {
      return LatLng(point[1], point[0]);
    }).toList();

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

  // 도착지에 도달했을 때 팝업 표시
  Future<void> _showArrivalPopup(
      BuildContext context, LatLng destination, LatLng startLocation) async {
    try {
      final locationSnapshot = await FirebaseFirestore.instance
          .collection('locationMap')
          .where('location', whereIn: [
        [destination.latitude, destination.longitude],
        [startLocation.latitude, startLocation.longitude]
      ]).get();

      if (locationSnapshot.docs.isNotEmpty) {
        for (var locationDoc in locationSnapshot.docs) {
          String stampUid = locationDoc['stampUid'];

          Map<String, dynamic>? stampDetail = await _fetchStampData(stampUid);
          if (stampDetail != null) {
            String userDocId = FirebaseAuth.instance.currentUser?.uid ?? "";
            await FirebaseFirestore.instance
                .collection('user')
                .doc(userDocId)
                .update({
              'stampId': FieldValue.arrayUnion([stampUid]),
            });

            // 스탬프 팝업 표시
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(stampDetail['stampName']),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.network(stampDetail['stampImageUrl']),
                      Text(stampDetail['location']),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('확인'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                );
              },
            );
          }
        }
      } else {
        print("No matching location found");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Firebase에서 스탬프 데이터를 가져옴
  Future<Map<String, dynamic>?> _fetchStampData(String stampUid) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('stamp')
        .doc(stampUid)
        .get();
    return snapshot.data() as Map<String, dynamic>?;
  }

  // 두 위치 사이의 거리를 계산
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000;
  }

  // Naver API를 사용하여 초기 경로 가져옴
  Future<void> _getNaverRoute() async {
    final url =
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
      final points = data['route']?['trafast']?.first['path'] ?? [];

      if (points.isNotEmpty) {
        _setPolylineFromNaverPoints(points);
      }
    } else {
      print('Failed to load directions: ${response.statusCode}');
    }
  }

  // Google Map 스타일 설정
  void _setMapStyle(GoogleMapController controller) async {
    const style = '''[
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
        backgroundColor: Colors.white,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _startLocation,
          zoom: 14.0,
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
