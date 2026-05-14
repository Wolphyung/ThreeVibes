import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../constants/colors.dart';
import '../services/location_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final LocationService _locationService = LocationService();

  LatLng _currentPosition = const LatLng(-21.4333, 47.0858);
  Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _loadReports();
  }

  Future<void> _getUserLocation() async {
    final position = await _locationService.getCurrentLocation();
    if (position != null) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      _animateToUserLocation();
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _animateToUserLocation() {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentPosition,
          zoom: 15,
        ),
      ),
    );
  }

  void _loadReports() {
    final List<Map<String, dynamic>> reports = [
      {
        'id': '1',
        'lat': -21.4330,
        'lng': 47.0855,
        'title': 'Problème d\'éclairage',
        'status': 'En cours',
      },
      {
        'id': '2',
        'lat': -21.4350,
        'lng': 47.0860,
        'title': 'Déchets accumulés',
        'status': 'En attente',
      },
      {
        'id': '3',
        'lat': -21.4320,
        'lng': 47.0845,
        'title': 'Route endommagée',
        'status': 'Résolu',
      },
    ];

    setState(() {
      _markers = reports.map((report) {
        final id = report['id'] as String;
        final lat = report['lat'] as double;
        final lng = report['lng'] as double;
        final title = report['title'] as String;
        final status = report['status'] as String;

        return Marker(
          markerId: MarkerId(id),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: title,
            snippet: 'Statut: $status',
          ),
          icon: _getMarkerIcon(status),
        );
      }).toSet();
    });
  }

  BitmapDescriptor _getMarkerIcon(String status) {
    if (status == 'Résolu') {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    } else if (status == 'En cours') {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    } else {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte des signalements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _animateToUserLocation,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 14,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
        compassEnabled: true,
        mapToolbarEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/report-form');
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_location_alt),
      ),
    );
  }
}
