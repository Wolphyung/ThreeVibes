import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../constants/colors.dart';
import '../services/location_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationService _locationService = LocationService();
  final MapController _mapController =
      MapController(); // Initialisé directement

  LatLng _currentPosition = const LatLng(-21.4333, 47.0858);
  List<Marker> _markers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _loadReports();
  }

  Future<void> _getUserLocation() async {
    final position = await _locationService.getCurrentLocation();
    if (position != null && mounted) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      // Déplacer la carte après un court délai pour s'assurer qu'elle est prête
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _mapController.move(_currentPosition, 14);
        }
      });
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadReports() {
    final reports = [
      {
        'id': '1',
        'lat': -21.4330,
        'lng': 47.0855,
        'title': 'Problème d\'éclairage',
        'status': 'En cours'
      },
      {
        'id': '2',
        'lat': -21.4350,
        'lng': 47.0860,
        'title': 'Déchets accumulés',
        'status': 'En attente'
      },
      {
        'id': '3',
        'lat': -21.4320,
        'lng': 47.0845,
        'title': 'Route endommagée',
        'status': 'Résolu'
      },
    ];

    setState(() {
      _markers = reports.map((report) {
        return Marker(
          width: 40,
          height: 40,
          point: LatLng(report['lat'] as double, report['lng'] as double),
          child: GestureDetector(
            onTap: () {
              _showMarkerDialog(
                  report['title'] as String, report['status'] as String);
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _getMarkerColor(report['status'] as String),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.report_problem,
                  color: Colors.white, size: 16),
            ),
          ),
        );
      }).toList();
    });
  }

  Color _getMarkerColor(String status) {
    switch (status) {
      case 'Résolu':
        return Colors.green;
      case 'En cours':
        return Colors.blue;
      default:
        return Colors.red;
    }
  }

  void _showMarkerDialog(String title, String status) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text('Statut: $status'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Chargement de la carte...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte des signalements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              _mapController.move(_currentPosition, 14);
            },
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentPosition,
          initialZoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.fianara.smartcity',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _markers,
          ),
        ],
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
