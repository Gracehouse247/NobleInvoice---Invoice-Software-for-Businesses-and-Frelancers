import 'package:flutter/material.dart';
import 'package:noble_invoice/data/models/folder_model.dart';
import 'package:noble_invoice/data/services/qr_service.dart';

class FolderController with ChangeNotifier {
  List<Folder> _folders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Folder> get folders => _folders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadFolders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _folders = await QrService.getFolders();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createFolder(String name, {String? iconName}) async {
    try {
      final newFolder = await QrService.createFolder(name, iconName: iconName);
      _folders.insert(0, newFolder);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFolder(String id) async {
    try {
      await QrService.deleteFolder(id);
      _folders.removeWhere((f) => f.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
