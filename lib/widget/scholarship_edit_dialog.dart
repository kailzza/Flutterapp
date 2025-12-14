import 'package:flutter/material.dart';
import '../models/scholarship_app.dart';

class ScholarshipEditDialog extends StatefulWidget {
  final ScholarshipApp app;
  const ScholarshipEditDialog({super.key, required this.app});

  @override
  State<ScholarshipEditDialog> createState() => _ScholarshipEditDialogState();
}

class _ScholarshipEditDialogState extends State<ScholarshipEditDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _providerController;
  late final TextEditingController _deadlineController;
  late final TextEditingController _notesController;
  AppStatus? _status;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.app.name);
    _providerController = TextEditingController(text: widget.app.provider);
    _deadlineController = TextEditingController(text: widget.app.deadline);
    _notesController = TextEditingController(text: widget.app.notes);
    _status = widget.app.status;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _providerController.dispose();
    _deadlineController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.app.id.isEmpty ? 'New Scholarship' : 'Edit Scholarship'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: _providerController, decoration: const InputDecoration(labelText: 'Provider')),
            TextField(controller: _deadlineController, decoration: const InputDecoration(labelText: 'Deadline')),
            DropdownButtonFormField<AppStatus>(
              initialValue: _status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: AppStatus.values
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                  .toList(),
              onChanged: (val) => setState(() => _status = val),
            ),
            TextField(controller: _notesController, decoration: const InputDecoration(labelText: 'Notes')),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final updated = ScholarshipApp(
              id: widget.app.id,
              name: _nameController.text.trim(),
              provider: _providerController.text.trim(),
              deadline: _deadlineController.text.trim(),
              status: _status ?? AppStatus.pending,
              notes: _notesController.text.trim(),
              lat: widget.app.lat,
              lng: widget.app.lng,
            );
            Navigator.pop(context, updated);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
