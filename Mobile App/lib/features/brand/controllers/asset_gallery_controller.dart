import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class AssetItem {
  final String id;
  final String path;
  final int sizeInBytes;
  final String title;

  AssetItem({
    required this.id,
    required this.path,
    required this.sizeInBytes,
    required this.title,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'path': path,
        'sizeInBytes': sizeInBytes,
        'title': title,
      };

  factory AssetItem.fromJson(Map<String, dynamic> json) => AssetItem(
        id: json['id'],
        path: json['path'],
        sizeInBytes: json['sizeInBytes'],
        title: json['title'],
      );
}

class AssetGalleryController extends ChangeNotifier {
  List<AssetItem> _assets = [];
  bool _isLoading = false;
  final _uuid = const Uuid();

  List<AssetItem> get assets => _assets;
  bool get isLoading => _isLoading;

  AssetGalleryController() {
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final String? assetsJson = prefs.getString('gallery_assets');
    
    if (assetsJson != null) {
      final List<dynamic> decoded = jsonDecode(assetsJson);
      _assets = decoded.map((item) => AssetItem.fromJson(item)).toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveAssets() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_assets.map((a) => a.toJson()).toList());
    await prefs.setString('gallery_assets', encoded);
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final size = await file.length();
      final title = pickedFile.name;
      
      final newItem = AssetItem(
        id: _uuid.v4(),
        path: pickedFile.path,
        sizeInBytes: size,
        title: title,
      );

      _assets.insert(0, newItem);
      notifyListeners();
      await _saveAssets();
    }
  }

  Future<void> deleteAsset(String id) async {
    _assets.removeWhere((element) => element.id == id);
    notifyListeners();
    await _saveAssets();
  }
}
