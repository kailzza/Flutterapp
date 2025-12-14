import 'package:flutter/material.dart';
import '../models/scholarship_app.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 36, backgroundColor: user.themeColor.withValues(alpha: 0.2), child: Text(user.username[0], style: TextStyle(color: user.themeColor))),
            const SizedBox(height: 12),
            Text(user.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 4),
            Text(user.email, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
