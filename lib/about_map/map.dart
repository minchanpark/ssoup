import 'dart:async';
import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ssoup/plogging/review_create_page.dart';
import 'package:ssoup/theme/text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GoogleMapPage extends StatefulWidget {
  final List startLocation;
  final List endLocation;
  final String courseId;

  const GoogleMapPage({
    super.key,
    required this.startLocation,
    required this.endLocation,
    required this.courseId,
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
  bool dialogShown = false;

  final String _googleAPIKey =
      'YOUR_GOOGLE_API_KEY'; // Replace with your Google API key

  @override
  void initState() {
    super.initState();
    _initializeLocations();
    _checkPermissions();
    _addInitialMarkers();
    _getGoogleDirections();
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
                30 &&
            !dialogShown) {
          _showArrivalPopup(context, _destinationLocation, _startLocation);
          dialogShown = true;
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
          infoWindow: const InfoWindow(title: '여기서 출발하세요!'),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('dL'),
          position: _destinationLocation,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: '여기서 스탬프를 얻을 수 있어요!'),
        ),
      );
    });
  }

  // Google Directions API를 사용하여 경로 데이터 가져오기
  Future<void> _getGoogleDirections() async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_startLocation.latitude},${_startLocation.longitude}&destination=${_destinationLocation.latitude},${_destinationLocation.longitude}&key=$_googleAPIKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final points =
          _decodePolyline(data['routes'][0]['overview_polyline']['points']);

      setState(() {
        _setPolylineFromGooglePoints(points);
      });
    } else {
      print('Failed to load directions: ${response.statusCode}');
    }
  }

  // 경로 데이터를 이용해 폴리라인을 지도에 추가
  void _setPolylineFromGooglePoints(List<LatLng> points) {
    setState(() {
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: points,
          color: Colors.blue,
          width: 5,
        ),
      );
    });
  }

  // Google Directions API에서 받아온 폴리라인 디코딩
  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> coordinates = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int b;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      coordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return coordinates;
  }

  // 도착지에 도달했을 때 팝업 표시
  Future<void> _showArrivalPopup(
      BuildContext context, LatLng destination, LatLng startLocation) async {
    // Firebase 데이터 가져오기 및 팝업 처리 로직은 기존 코드와 동일
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
