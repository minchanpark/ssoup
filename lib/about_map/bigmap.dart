import 'dart:async';
import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ssoup/constants.dart';
import 'package:ssoup/theme/color.dart';
import 'package:ssoup/theme/text.dart';

class BigMapPage extends StatefulWidget {
  const BigMapPage({super.key});

  @override
  State<BigMapPage> createState() => _BigMapPageState();
}

class _BigMapPageState extends State<BigMapPage> {
  GoogleMapController? _mapController;
  final LatLng _ulleungDo = const LatLng(37.49893355978079, 130.86866855621338);
  final Set<Marker> _allMarkers = {};
  final Set<Marker> _currentMarkers = {};
  final Set<Marker> _touristMarkers = {};
  final Set<Marker> _trashMarkers = {};
  final Set<Polyline> _polylines = {};
  StreamSubscription<Position>? _positionStreamSubscription;
  LatLng? _currentLocation;

  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _determinePosition().then((position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _addCurrentLocationMarker();
        _getLocationsFromFB();
        _getTrashLocationsFromFB();
      });
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _addCurrentLocationMarker() {
    if (_currentLocation == null) return;

    final Marker currentLocationMarker = Marker(
      markerId: const MarkerId('currentLocation'),
      position: _currentLocation!,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: const InfoWindow(title: 'Current Location'),
    );
    _currentMarkers.add(currentLocationMarker);
    _allMarkers.add(currentLocationMarker);
  }

  Future<void> _getLocationsFromFB() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('locationMap').get();

    print("Number of documents: ${snapshot.docs.length}");

    setState(() {
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        print("Data: $data");

        final LatLng location =
            LatLng(data['location'][0], data['location'][1]);
        final String name = data['locationName'];
        final String information = data['information'];

        final Marker touristMarker = Marker(
          markerId: MarkerId(doc.id),
          position: location,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () {
            _showMarkerInfoDialog(name, information);
          },
        );
        _touristMarkers.add(touristMarker);
        _allMarkers.add(touristMarker);
      }
      _currentMarkers.addAll(_touristMarkers);
    });
  }

  Future<void> _getTrashLocationsFromFB() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('trashMap').get();

    setState(() {
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final LatLng location =
            LatLng(data['location'][0], data['location'][1]);

        final Marker trashMarker = Marker(
          markerId: MarkerId(doc.id),
          position: location,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Trash Bin'),
          onTap: () {
            _getNaverRoute(location);
          },
        );
        _trashMarkers.add(trashMarker);
        _allMarkers.add(trashMarker);
      }
      _currentMarkers.addAll(_trashMarkers);
    });
  }

  Future<void> _getNaverRoute(LatLng destination) async {
    if (_currentLocation == null) return;

    final String url =
        'https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving?start=${_currentLocation!.longitude},${_currentLocation!.latitude}&goal=${destination.longitude},${destination.latitude}&option=trafast';

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
          _currentLocation!.latitude,
          _currentLocation!.longitude,
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

  void _filterMarkers(String filter) {
    setState(() {
      _selectedFilter = filter;
      _currentMarkers.clear();
      if (filter == 'all') {
        _currentMarkers.addAll(_touristMarkers);
        _currentMarkers.addAll(_trashMarkers);
      } else if (filter == 'tourist') {
        _currentMarkers.addAll(_touristMarkers);
      } else if (filter == 'trash') {
        _currentMarkers.addAll(_trashMarkers);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          '울릉투어 맵',
          style: regular23,
        ),
        backgroundColor: const Color(0xffC6EBFE),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xffC6EBFE),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChoiceChip(
                    label: const Text(
                      '전체지도',
                      style: regular15,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    selected: _selectedFilter == 'all',
                    onSelected: (bool selected) {
                      _filterMarkers('all');
                    },
                    selectedColor: AppColor.primary,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Color(0xffC6EBFE))),
                    showCheckmark: false,
                  ),
                  ChoiceChip(
                    label: const Text('관광지', style: regular15),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    selected: _selectedFilter == 'tourist',
                    onSelected: (bool selected) {
                      _filterMarkers('tourist');
                    },
                    selectedColor: AppColor.primary,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Color(0xffC6EBFE))),
                    showCheckmark: false,
                  ),
                  ChoiceChip(
                    label: const Text('쓰레기통', style: regular15),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    selected: _selectedFilter == 'trash',
                    onSelected: (bool selected) {
                      _filterMarkers('trash');
                    },
                    selectedColor: AppColor.primary,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Color(0xffC6EBFE))),
                    showCheckmark: false,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _ulleungDo,
                zoom: 11.8,
              ),
              markers: _currentMarkers,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                _setMapStyle(controller);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              polylines: _polylines,
            ),
          ),
        ],
      ),
    );
  }
}
