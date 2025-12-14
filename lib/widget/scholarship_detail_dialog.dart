import 'package:flutter/material.dart';
import '../models/scholarship_app.dart';

class ScholarshipDetailDialog extends StatelessWidget {
  final ScholarshipApp app;

  const ScholarshipDetailDialog({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(app.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Provider', app.provider),
          const SizedBox(height: 8),
          _buildInfoRow('Deadline', app.deadline),
          const SizedBox(height: 8),
          _buildInfoRow('Status', app.status.label),
          const SizedBox(height: 16),
          const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(app.notes, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
