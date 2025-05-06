import 'package:flutter/material.dart';

class AppStyles {
  // Espaciado
  static const double padding = 16.0;
  static const double cardRadius = 24.0;

  // Colores
  static const Color background = Color(0xFFF9F6F2);
  static const Color card = Colors.white;
  static const Color accent = Colors.deepOrange;
  static const Color darkText = Colors.black87;
  static const Color lightText = Colors.grey;

  // Sombras
  static final BoxShadow shadow = BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 16,
    offset: const Offset(0, 8),
  );

  // Texto
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: darkText,
  );
}
