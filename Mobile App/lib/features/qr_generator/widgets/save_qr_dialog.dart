import 'package:flutter/material.dart';
import 'package:noble_invoice/data/models/folder_model.dart';
import 'package:noble_invoice/data/models/qr_code_model.dart';
import 'package:noble_invoice/data/services/qr_service.dart';

class SaveQrDialog extends StatefulWidget {
  final QrCode qrCode;

  const SaveQrDialog({super.key, required this.qrCode});

  @override
  State<SaveQrDialog> createState() => _SaveQrDialogState();
}

class _SaveQrDialogState extends State<SaveQrDialog> {
  List<Folder> _folders = [];
  String? _selectedFolderId;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    try {
      final folders = await QrService.getFolders();
      setState(() {
        _folders = folders;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final newQr = QrCode(
        name: widget.qrCode.name,
        type: widget.qrCode.type,
        content: widget.qrCode.content,
        colorPrimary: widget.qrCode.colorPrimary,
        folderId: _selectedFolderId,
        assetPath: widget.qrCode.assetPath,
        qrImagePath: widget.qrCode.qrImagePath,
      );
      await QrService.saveQrCode(newQr);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Save to Folder', style: TextStyle(fontWeight: FontWeight.bold)),
      content: _isLoading 
        ? const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()))
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select a folder to save this QR code for easy access later.'),
              const SizedBox(height: 20),
              if (_folders.isEmpty)
                const Text('No folders found. You can create one in the Library section.')
              else
                DropdownButtonFormField<String>(
                  initialValue: _selectedFolderId,
                  decoration: const InputDecoration(
                    labelText: 'Choose Folder',
                    border: OutlineInputBorder(),
                  ),
                  items: _folders.map((f) => DropdownMenuItem(value: f.id, child: Text(f.name))).toList(),
                  onChanged: (val) => setState(() => _selectedFolderId = val),
                ),
            ],
          ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _isSaving ? null : _save, 
          child: _isSaving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save to Cloud'),
        ),
      ],
    );
  }
}
