import 'package:flutter/material.dart';

class AppColors {
  static const Color cor5 = Color(0xFF003358);
  // Cores principais
  static const Color cor1 = Color(0xFF1A1A2E); // Fundo escuro principal
  static const Color cor2 = Color(0xFF16213E); // Fundo escuro secundário
  static const Color cor3 = Color(0xFF0F3460); // Cor de destaque média
  static const Color cor4 = Color(
    0xFFE94560,
  ); // Cor de destaque principal (vermelho/rosa)

  // Cores complementares
  static const Color accent1 = Color(
    0xFF00B4D8,
  ); // Azul claro para destaques secundários
  static const Color accent2 = Color(
    0xFF7209B7,
  ); // Roxo para elementos especiais
  static const Color accent3 = Color(
    0xFF4CC9F0,
  ); // Azul ciano para elementos interativos

  // Cores de status
  static const Color success = Color(0xFF4CAF50); // Verde para sucesso
  static const Color warning = Color(0xFFFFC107); // Amarelo para avisos
  static const Color error = Color(0xFFFF5252); // Vermelho para erros
  static const Color info = Color(0xFF2196F3); // Azul para informações

  // Cores de texto
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textDisabled = Color(0xFF757575);

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [cor3, cor4],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent1, accent2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Sombras
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black,
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Colors.black,
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];
}
