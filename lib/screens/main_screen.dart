import 'package:flutter/material.dart';
import 'package:scholar_track/models/scholarship_app.dart';
import 'package:scholar_track/screens/dashboard_screen.dart';
import 'package:latlong2/latlong.dart';
import 'package:scholar_track/screens/map_screen.dart';
import 'package:scholar_track/screens/profile_screen.dart';
import 'package:scholar_track/screens/tracker_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    // Placeholder user & apps for demo. Replace with provider state.
    final user = User(username: 'You', email: 'you@example.com');
    final apps = <ScholarshipApp>[];
    _screens.addAll([
      DashboardScreen(user: user, apps: apps),
      TrackerScreen(apps: apps),
      MapScreen(apps: apps, initialCenter: const LatLng(15.922, 120.350)),
      ProfileScreen(user: user),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.track_changes), label: 'Tracker'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
