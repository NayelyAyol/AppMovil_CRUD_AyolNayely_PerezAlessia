import 'package:flutter/material.dart';

/// Paleta inspirada en bibliotecas antiguas, papel envejecido
/// y portadas de novelas románticas vintage.
class AppColors {
  static const Color crema = Color(0xFFF4ECD8); // fondo general (papel)
  static const Color pergamino = Color(0xFFFBF3E2); // tarjetas / superficies
  static const Color vino = Color(0xFF6F1D1B); // color principal (tapas de cuero)
  static const Color vinoOscuro = Color(0xFF4E1116); // acentos oscuros
  static const Color dorado = Color(0xFFC9A66B); // detalles dorados
  static const Color oxido = Color(0xFFB5651D); // botones de acción (sello postal)
  static const Color marronTexto = Color(0xFF3E2723); // texto principal
  static const Color verdeBiblioteca = Color(0xFF5C6B4F); // acento secundario
}

class AppTheme {
  static ThemeData get tema {
    final ThemeData base = ThemeData(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.crema,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.vino,
        primary: AppColors.vino,
        secondary: AppColors.dorado,
        surface: AppColors.pergamino,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.vino,
        foregroundColor: AppColors.crema,
        centerTitle: true,
        elevation: 2,
        titleTextStyle: TextStyle(
          fontFamily: 'Georgia',
          fontWeight: FontWeight.bold,
          fontSize: 22,
          letterSpacing: 0.6,
          color: AppColors.crema,
        ),
        iconTheme: IconThemeData(color: AppColors.crema),
      ),
      textTheme: base.textTheme.apply(
        fontFamily: 'Georgia',
        bodyColor: AppColors.marronTexto,
        displayColor: AppColors.marronTexto,
      ),
      cardTheme: CardThemeData(
        color: AppColors.pergamino,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: AppColors.dorado.withOpacity(0.6),
            width: 1.2,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.vino,
          foregroundColor: AppColors.crema,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.vino,
          side: const BorderSide(color: AppColors.vino, width: 1.4),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.oxido,
        foregroundColor: AppColors.crema,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.pergamino,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.dorado),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.dorado),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColors.vino, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.marronTexto),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.vinoOscuro,
        contentTextStyle: TextStyle(color: AppColors.crema),
        behavior: SnackBarBehavior.floating,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.dorado.withOpacity(0.35),
        labelStyle: const TextStyle(color: AppColors.marronTexto, fontWeight: FontWeight.w600),
        side: BorderSide.none,
      ),
    );
  }
}