import 'package:flutter/material.dart';
import 'package:scholar_track/services/http_api_service.dart';
import '../models/scholarship_app.dart';
import '../widget/app_list_item.dart';
import '../widget/scholarship_detail_dialog.dart';
import '../widget/scholarship_edit_dialog.dart';

class TrackerScreen extends StatefulWidget {
  final List<ScholarshipApp> apps;

  const TrackerScreen({super.key, required this.apps});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  AppStatus? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    final filteredApps = _selectedFilter == null 
        ? widget.apps 
        : widget.apps.where((a) => a.status == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Tracker'),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildFilterChip(null, 'All'),
                ...AppStatus.values.map((s) => _buildFilterChip(s, s.label)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredApps.length,
              itemBuilder: (context, index) {
                final app = filteredApps[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: AppListItem(
                    app: app, 
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => ScholarshipDetailDialog(app: app),
                      );
                    },
                    onEdit: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final updated = await showDialog<ScholarshipApp>(
                        context: context,
                        builder: (_) => ScholarshipEditDialog(app: app),
                      );
                      if (updated != null) {
                        await HttpApiService.instance.addOrUpdateScholarship(updated);
                        messenger.showSnackBar(const SnackBar(content: Text('Updated scholarship')));
                      }
                    },
                    onDelete: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: const Text('Confirm delete'),
                          content: const Text('Delete scholarship?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                            ElevatedButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        final ok = await HttpApiService.instance.deleteScholarship(app.id);
                        messenger.showSnackBar(SnackBar(content: Text(ok ? 'Deleted' : 'Failed to delete')));
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(AppStatus? status, String label) {
    final isSelected = _selectedFilter == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = selected ? status : null;
          });
        },
        selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        checkmarkColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
