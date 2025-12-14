import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/scholarship_app.dart';

class MapScreen extends StatelessWidget {
  final List<ScholarshipApp> apps;
  final LatLng initialCenter;

  const MapScreen({
    super.key, 
    required this.apps, 
    required this.initialCenter
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: initialCenter,
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.scholartrack.app',
          ),
          MarkerLayer(
            markers: apps.where((a) => a.lat != null).map((app) {
              return Marker(
                point: LatLng(app.lat!, app.lng!),
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () {
                     showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                           title: Text(app.name),
                           content: Text('Deadline: ${app.deadline}'),
                        )
                     );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: app.status.color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: const [BoxShadow(blurRadius: 5)],
                    ),
                    child: const Icon(Icons.school, color: Colors.white, size: 20),
                  ),
                  ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
