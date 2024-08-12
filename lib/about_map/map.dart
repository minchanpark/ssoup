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

  const GoogleMapPage(
      {super.key, required this.startLocation, required this.endLocation});

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
    _locationInit();
    _checkPermissions();
    _setInitialMarkers();
    _getNaverRoute();
  }

  void _locationInit() {
    _startLocation = LatLng(widget.startLocation[0], widget.startLocation[1]);
    _destinationLocation = LatLng(widget.endLocation[0], widget.endLocation[1]);
    _currentPosition = LatLng(widget.startLocation[0], widget.startLocation[1]);
    // Debug message to check if locations are initialized
    print('Initialized Start Location: $_startLocation');
    print('Initialized Destination Location: $_destinationLocation');
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    final currentPosition = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    setState(() {
      _currentPosition =
          LatLng(currentPosition.latitude, currentPosition.longitude);
      _updateCurrentLocationMarker();
    });

    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      if (!mounted) return;
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _updateCurrentLocationMarker();

        double distance = _calculateDistance(
          _currentPosition.latitude,
          _currentPosition.longitude,
          _destinationLocation.latitude,
          _destinationLocation.longitude,
        );

        if (distance <= 30) {
          _showArrivalPopup(context, _destinationLocation);
        }
      });
    });
  }

  Future<Map<String, dynamic>?> _fetchStampData(String stampUid) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('stamp')
        .doc(stampUid)
        .get();
    return snapshot.data() as Map<String, dynamic>?;
  }

  Future<void> _showArrivalPopup(
      BuildContext context, LatLng _destinationLocation) async {
    double destinationLatitude = _destinationLocation.latitude;
    double destinationLongitude = _destinationLocation.longitude;

    // locationMap에서 목적지 좌표와 일치하는 문서가 있는지 확인
    QuerySnapshot locationSnapshot = await FirebaseFirestore.instance
        .collection('locationMap')
        .where('location',
            isEqualTo: [destinationLatitude, destinationLongitude]).get();

    if (locationSnapshot.docs.isNotEmpty) {
      // 일치하는 첫 번째 문서 가져오기
      var locationDoc = locationSnapshot.docs.first;
      String stampUid = locationDoc['stampUid'];

      // 스탬프 데이터 가져오기
      Map<String, dynamic>? stampDetail = await _fetchStampData(stampUid);

      if (stampDetail != null) {
        // 현재 사용자의 docId를 가져옵니다. 여기서는 user 컬렉션의 docId가 현재 사용자의 ID라고 가정합니다.
        String userDocId = FirebaseAuth.instance.currentUser?.uid ?? "";
        ; // 현재 사용자의 docId로 변경해야 합니다.

        // user 컬렉션에서 해당 문서에 stampUid 추가
        await FirebaseFirestore.instance
            .collection('user')
            .doc(userDocId)
            .update({
          'stampId': FieldValue.arrayUnion([stampUid]),
        }).catchError((error) {
          print("Failed to update stampId: $error");
        });

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
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        print("stampUid: $stampUid에 대한 스탬프 정보를 찾을 수 없습니다.");
      }
    } else {
      print(
          "좌표에 대한 위치를 찾을 수 없습니다: $destinationLatitude, $destinationLongitude");
    }
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Math.PI / 180
    final c = cos;
    final a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 *
        asin(sqrt(a)) *
        1000; // 2 * R; R = 6371 km, convert to meters
  }

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
          color: Colors.blue,
          width: 5,
        ),
      );
    });
  }

  void _setInitialMarkers() {
    if (!mounted) return;
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
