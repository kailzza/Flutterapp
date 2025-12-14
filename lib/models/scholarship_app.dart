import 'package:flutter/material.dart';

enum AppStatus {
  submitted('Submitted', Color(0xFF2563EB)), // Blue
  pending('Pending', Color(0xFFD97706)),     // Amber
  approved('Approved', Color(0xFF059669)),   // Green
  declined('Declined', Color(0xFFDC2626));   // Red

  const AppStatus(this.label, this.color);
  final String label;
  final Color color;
}

class ScholarshipApp {
  final String id;
  final String name;
  final String provider;
  final String deadline;
  final String notes;
  AppStatus status;
  // Mock coordinates for map
  final double? lat;
  final double? lng;

  ScholarshipApp({
    required this.id,
    required this.name,
    required this.provider,
    required this.deadline,
    required this.status,
    this.notes = '',
    this.lat,
    this.lng,
  });

  factory ScholarshipApp.fromMap(String id, Map<String, dynamic> data) {
    final statusStr = (data['status'] ?? 'pending') as String;
    final status = AppStatus.values.firstWhere(
      (s) => s.name == statusStr || s.label.toLowerCase() == statusStr.toLowerCase(),
      orElse: () => AppStatus.pending,
    );
    return ScholarshipApp(
      id: id,
      name: data['name'] as String? ?? '',
      provider: data['provider'] as String? ?? '',
      deadline: data['deadline'] as String? ?? '',
      status: status,
      notes: data['notes'] as String? ?? '',
      lat: (data['lat'] != null) ? (data['lat'] as num).toDouble() : null,
      lng: (data['lng'] != null) ? (data['lng'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'provider': provider,
    'deadline': deadline,
    'status': status.name,
    'notes': notes,
    'lat': lat,
    'lng': lng,
  };
}

class User {
  final String username;
  final String email;
  final Color themeColor;

  User({
    required this.username,
    required this.email,
    this.themeColor = const Color(0xFF2563EB),
  });
}
