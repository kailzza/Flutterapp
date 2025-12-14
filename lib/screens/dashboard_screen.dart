import 'package:flutter/material.dart';
import '../models/scholarship_app.dart';
import '../widget/stat_card.dart';
import '../widget/app_list_item.dart';
import '../widget/scholarship_detail_dialog.dart';
import '../widget/scholarship_edit_dialog.dart';
import 'package:scholar_track/services/http_api_service.dart';

class DashboardScreen extends StatelessWidget {
  final User user;
  final List<ScholarshipApp> apps;

  const DashboardScreen({
    super.key, 
    required this.user, 
    required this.apps
  });

  @override
  Widget build(BuildContext context) {
    // Calculate stats
    final approvedCount = apps.where((a) => a.status == AppStatus.approved).length;
    final pendingCount = apps.where((a) => a.status == AppStatus.pending).length;
    final totalCount = apps.length;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newApp = ScholarshipApp(id: '', name: '', provider: '', deadline: '', status: AppStatus.pending, notes: '', lat: null, lng: null);
          final messenger = ScaffoldMessenger.of(context);
          final created = await showDialog<ScholarshipApp?>(context: context, builder: (_) => ScholarshipEditDialog(app: newApp));
          if (created != null) {
            await HttpApiService.instance.createScholarship(created);
            messenger.showSnackBar(const SnackBar(content: Text('Added scholarship')));
          }
        },
        tooltip: 'Add sample',
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome back,', style: TextStyle(fontSize: 14, color: Color(0xFF757575))),
            Text(user.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        actions: [
          IconButton(
            icon: CircleAvatar(
            backgroundColor: user.themeColor.withValues(alpha: 0.2),
               child: Text(user.username[0], style: TextStyle(color: user.themeColor)),
            ),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: StatCard(label: 'Total Apps', value: '$totalCount', color: Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: StatCard(label: 'Pending', value: '$pendingCount', color: Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: StatCard(label: 'Approved', value: '$approvedCount', color: Colors.green)),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Recent Applications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: apps.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final app = apps[index];
                return AppListItem(
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
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (c) => AlertDialog(
                        title: const Text('Confirm delete'),
                        content: const Text('Are you sure you want to delete this scholarship?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                          ElevatedButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      final ok = await HttpApiService.instance.deleteScholarship(app.id);
                      messenger.showSnackBar(SnackBar(content: Text(ok ? 'Deleted' : 'Failed to delete')));
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
