import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/report_model.dart';
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
  List<ReportModel> _nearbyReports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _fetchNearby(_currentPosition);
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

  Future<void> _fetchNearby(LatLng position) async {
    try {
      final uri = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.signalements}/nearby?lat=${position.latitude}&lng=${position.longitude}&count=50',
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> reportsData = data['data'] ?? [];
        if (mounted) {
          setState(() {
            _nearbyReports = reportsData
                .map((json) => ReportModel.fromJson(json))
                .toList();
          });
        }
      }
    } catch (e) {
      print('Error fetching nearby signalements: $e');
    }
  }

  void _showMarkerDialog(ReportModel report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(report.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: report.status.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                report.status.label,
                style: TextStyle(
                    color: report.status.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),
            Text(report.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('FERMER'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/report-detail', arguments: report);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('VOIR DÉTAILS',
                style: TextStyle(color: Colors.white)),
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
          onPositionChanged: (position, hasGesture) {
            if (hasGesture) {
              _fetchNearby(position.center!);
            }
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.threevibes.app.fianara_smart_city',
          ),
          MarkerLayer(
            markers: [
              // User position marker
              Marker(
                point: _currentPosition,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.my_location,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
              // Nearby reports markers
              ..._nearbyReports.map((report) {
                return Marker(
                  point: LatLng(report.latitude, report.longitude),
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onTap: () => _showMarkerDialog(report),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: report.status.color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        report.type.icon,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                );
              }),
            ],
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
