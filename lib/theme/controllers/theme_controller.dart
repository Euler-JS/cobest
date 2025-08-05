import 'package:flutter/material.dart';
import 'package:cobes_marketplace/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController with ChangeNotifier {
  final SharedPreferences? sharedPreferences;
  ThemeController({required this.sharedPreferences}) {
    _loadCurrentTheme();
  }

  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    sharedPreferences!.setBool(AppConstants.theme, _darkTheme);
    notifyListeners();
  }

  void _loadCurrentTheme() async {
    _darkTheme = sharedPreferences!.getBool(AppConstants.theme) ?? false;
    notifyListeners();
  }

  // Cores padrão baseadas no logo da Cobest
  Color? selectedPrimaryColor = const Color(0xFFD2691E); // Laranja Cobest
  Color? selectedSecondaryColor = const Color(0xFF4A4A4A); // Cinza escuro Cobest

  void setThemeColor({Color? primaryColor, Color? secondaryColor}) {
    selectedPrimaryColor = primaryColor ?? const Color(0xFFD2691E);
    selectedSecondaryColor = secondaryColor ?? const Color(0xFF4A4A4A);

    notifyListeners();
  }

  // Método para resetar para as cores padrão da Cobest
  void resetToCobestColors() {
    selectedPrimaryColor = const Color(0xFFD2691E);
    selectedSecondaryColor = const Color(0xFF4A4A4A);
    notifyListeners();
  }

  // Getters para as cores atuais
  Color get currentPrimaryColor => selectedPrimaryColor ?? const Color(0xFFD2691E);
  Color get currentSecondaryColor => selectedSecondaryColor ?? const Color(0xFF4A4A4A);
}