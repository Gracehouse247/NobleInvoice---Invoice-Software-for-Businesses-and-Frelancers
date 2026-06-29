import 'dart:io';
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart';

class DayOpeningHours {
  final String day;
  bool isOpen;
  TimeOfDay from;
  TimeOfDay to;

  DayOpeningHours({
    required this.day,
    this.isOpen = true,
    required this.from,
    required this.to,
  });
}

class BusinessQRController with ChangeNotifier {
  Color _primaryColor = AppColors.primary;
  String _companyName = '';
  String _headline = '';
  String _website = '';
  final List<DayOpeningHours> _openingHours = [
    DayOpeningHours(day: 'Monday', from: const TimeOfDay(hour: 9, minute: 0), to: const TimeOfDay(hour: 17, minute: 0)),
    DayOpeningHours(day: 'Tuesday', from: const TimeOfDay(hour: 9, minute: 0), to: const TimeOfDay(hour: 17, minute: 0)),
    DayOpeningHours(day: 'Wednesday', from: const TimeOfDay(hour: 9, minute: 0), to: const TimeOfDay(hour: 17, minute: 0)),
    DayOpeningHours(day: 'Thursday', from: const TimeOfDay(hour: 9, minute: 0), to: const TimeOfDay(hour: 17, minute: 0)),
    DayOpeningHours(day: 'Friday', from: const TimeOfDay(hour: 9, minute: 0), to: const TimeOfDay(hour: 17, minute: 0)),
    DayOpeningHours(day: 'Saturday', isOpen: false, from: const TimeOfDay(hour: 10, minute: 0), to: const TimeOfDay(hour: 14, minute: 0)),
    DayOpeningHours(day: 'Sunday', isOpen: false, from: const TimeOfDay(hour: 10, minute: 0), to: const TimeOfDay(hour: 14, minute: 0)),
  ];
  String _street = '';
  String _city = '';
  String _postalCode = '';
  String _country = '';
  String _phone = '';
  String _email = '';
  String _fax = '';
  final Map<String, String> _socialLinks = {
    'facebook': '',
    'instagram': '',
    'twitter': '',
    'linkedin': '',
  };
  String _aboutCompany = '';
  final List<String> _selectedFacilities = [];
  File? _welcomeImage;
  String _welcomeText = '';
  String _qrName = '';
  String _password = '';
  bool _isPasswordEnabled = false;
  bool _obscurePassword = true;

  Color get primaryColor => _primaryColor;
  String get companyName => _companyName;
  String get headline => _headline;
  String get website => _website;
  List<DayOpeningHours> get openingHours => _openingHours;
  String get street => _street;
  String get city => _city;
  String get postalCode => _postalCode;
  String get country => _country;
  String get phone => _phone;
  String get email => _email;
  String get fax => _fax;
  Map<String, String> get socialLinks => _socialLinks;
  String get aboutCompany => _aboutCompany;
  List<String> get selectedFacilities => _selectedFacilities;
  File? get welcomeImage => _welcomeImage;
  String get welcomeText => _welcomeText;
  String get qrName => _qrName;
  String get password => _password;
  bool get isPasswordEnabled => _isPasswordEnabled;
  bool get obscurePassword => _obscurePassword;

  void setPrimaryColor(Color color) {
    _primaryColor = color;
    notifyListeners();
  }

  void setCompanyName(String name) {
    _companyName = name;
    notifyListeners();
  }

  void setHeadline(String text) {
    _headline = text;
    notifyListeners();
  }

  void setWebsite(String url) {
    _website = url;
    notifyListeners();
  }

  void toggleDay(int index, bool isOpen) {
    _openingHours[index].isOpen = isOpen;
    notifyListeners();
  }

  void setFromTime(int index, TimeOfDay time) {
    _openingHours[index].from = time;
    notifyListeners();
  }

  void setToTime(int index, TimeOfDay time) {
    _openingHours[index].to = time;
    notifyListeners();
  }

  void setStreet(String value) {
    _street = value;
    notifyListeners();
  }

  void setCity(String value) {
    _city = value;
    notifyListeners();
  }

  void setPostalCode(String value) {
    _postalCode = value;
    notifyListeners();
  }

  void setCountry(String value) {
    _country = value;
    notifyListeners();
  }

  void setPhone(String value) {
    _phone = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setFax(String value) {
    _fax = value;
    notifyListeners();
  }

  void setSocialLink(String platform, String url) {
    _socialLinks[platform] = url;
    notifyListeners();
  }

  void setAboutCompany(String value) {
    _aboutCompany = value;
    notifyListeners();
  }

  void toggleFacility(String facility) {
    if (_selectedFacilities.contains(facility)) {
      _selectedFacilities.remove(facility);
    } else {
      _selectedFacilities.add(facility);
    }
    notifyListeners();
  }

  Future<void> pickWelcomeImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _welcomeImage = File(image.path);
      notifyListeners();
    }
  }

  void setWelcomeText(String text) {
    _welcomeText = text;
    notifyListeners();
  }

  void setQrName(String name) {
    _qrName = name;
    notifyListeners();
  }

  void setPassword(String pass) {
    _password = pass;
    notifyListeners();
  }

  void togglePasswordProtection(bool isEnabled) {
    _isPasswordEnabled = isEnabled;
    if (!isEnabled) {
      _password = '';
    }
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void loadFromContent(Map<String, dynamic> content, {String? name, Color? color}) {
    if (name != null) _qrName = name;
    if (color != null) _primaryColor = color;
    
    _companyName = content['name'] ?? '';
    _headline = content['headline'] ?? '';
    _website = content['website'] ?? '';
    _phone = content['phone'] ?? '';
    _email = content['email'] ?? '';
    
    final address = content['address']?.toString() ?? '';
    if (address.contains(',')) {
      final parts = address.split(',');
      _street = parts[0].trim();
      _city = parts[1].trim();
    } else {
      _street = address;
    }

    if (content['social'] is Map) {
      final social = content['social'] as Map;
      social.forEach((key, value) {
        if (_socialLinks.containsKey(key)) {
          _socialLinks[key] = value.toString();
        }
      });
    }

    _aboutCompany = content['about'] ?? '';
    _welcomeText = content['welcome'] ?? '';
    
    notifyListeners();
  }
}

