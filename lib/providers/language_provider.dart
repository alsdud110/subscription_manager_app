import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../services/storage_service.dart';

class LanguageProvider extends ChangeNotifier {
  String _languageCode = AppStrings.korean; // Default to Korean
  final StorageService _storageService = StorageService();

  String get languageCode => _languageCode;

  bool get isKorean => _languageCode == AppStrings.korean;
  bool get isEnglish => _languageCode == AppStrings.english;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    _languageCode = await _storageService.loadLanguage();
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    if (_languageCode != languageCode) {
      _languageCode = languageCode;
      await _storageService.saveLanguage(languageCode);
      notifyListeners();
    }
  }

  Future<void> toggleLanguage() async {
    final newLanguage = _languageCode == AppStrings.korean
        ? AppStrings.english
        : AppStrings.korean;
    await setLanguage(newLanguage);
  }

  String tr(String key) {
    return AppStrings.get(key, _languageCode);
  }
}
