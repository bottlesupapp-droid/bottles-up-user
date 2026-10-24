import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Core Brand Colors
  static const Color _backgroundColor = Color(0xFF171214);
  static const Color _primaryColor = Color(0xFFFF6B00);
  
  // Surface Colors (proper contrast)
  static const Color _surfaceColor = Color(0xFF241F21);
  static const Color _surfaceVariantColor = Color(0xFF2D2528);
  
  // Text Colors (high contrast)
  static const Color _onSurfaceColor = Color(0xFFE8E3E5);
  static const Color _onSurfaceVariantColor = Color(0xFFB8B0B3);
  static const Color _onBackgroundColor = Color(0xFFE8E3E5);
  
  // Secondary Colors
  static const Color _secondaryColor = Color(0xFF8A7A7D);
  static const Color _tertiaryColor = Color(0xFF6B5B5E);
  
  // Semantic Colors
  static const Color _errorColor = Color(0xFFFF5449);
  static const Color _successColor = Color(0xFF4CAF50);
  static const Color _warningColor = Color(0xFFFFC107);

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      // Primary Colors
      primary: _primaryColor,
      onPrimary: Colors.white,
      primaryContainer: _primaryColor.withOpacity(0.2),
      onPrimaryContainer: _primaryColor.withOpacity(0.8),
      
      // Secondary Colors
      secondary: _secondaryColor,
      onSecondary: Colors.white,
      secondaryContainer: _secondaryColor.withOpacity(0.2),
      onSecondaryContainer: _secondaryColor,
      
      // Tertiary Colors
      tertiary: _tertiaryColor,
      onTertiary: Colors.white,
      tertiaryContainer: _tertiaryColor.withOpacity(0.2),
      onTertiaryContainer: _tertiaryColor,
      
      // Surface Colors
      surface: _surfaceColor,
      onSurface: _onSurfaceColor,
      surfaceContainerHighest: _surfaceVariantColor,
      onSurfaceVariant: _onSurfaceVariantColor,
      
      // Semantic Colors
      error: _errorColor,
      onError: Colors.white,
      
      // Outline Colors
      outline: _onSurfaceVariantColor.withOpacity(0.3),
      outlineVariant: _onSurfaceVariantColor.withOpacity(0.15),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _backgroundColor,
      fontFamily: 'Inter',
      
      // Container Theme - Force dark containers
      canvasColor: _surfaceColor,
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: _backgroundColor,
        foregroundColor: _onBackgroundColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: _onBackgroundColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: _onBackgroundColor,
          size: 24,
        ),
      ),
      
      // Text Themes
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: _onBackgroundColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: _onBackgroundColor,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: _onBackgroundColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: _onBackgroundColor,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: _onBackgroundColor,
          fontSize: 20,
          letterSpacing: 0.3,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: _onBackgroundColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: _onBackgroundColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: _onBackgroundColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: _onSurfaceVariantColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: _onBackgroundColor,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: _onBackgroundColor,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: _onSurfaceVariantColor,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          color: _onBackgroundColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: _onSurfaceVariantColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: _onSurfaceVariantColor,
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryColor,
          side: const BorderSide(color: _primaryColor, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      
      // Input Decoration Theme (Text Fields)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceColor,
        hintStyle: const TextStyle(
          color: _onSurfaceVariantColor,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          color: _onSurfaceVariantColor,
          fontSize: 14,
        ),
        prefixIconColor: _onSurfaceVariantColor,
        suffixIconColor: _onSurfaceVariantColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _onSurfaceVariantColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _onSurfaceVariantColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: _primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: _errorColor,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: _surfaceColor,
        selectedColor: _primaryColor,
        disabledColor: _surfaceColor.withOpacity(0.5),
        labelStyle: const TextStyle(
          color: _onSurfaceColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(
          color: _onSurfaceVariantColor.withOpacity(0.2),
          width: 1,
        ),
        elevation: 2,
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: _surfaceColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: _surfaceColor,
        modalBackgroundColor: _surfaceColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: double.infinity,
        ),
        clipBehavior: Clip.antiAlias,
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: _surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          color: _onSurfaceColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(
          color: _onSurfaceColor,
          fontSize: 14,
        ),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: _onSurfaceColor,
        size: 24,
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: _onSurfaceVariantColor.withOpacity(0.2),
        thickness: 1,
      ),
      
      // ListTile Theme
      listTileTheme: ListTileThemeData(
        iconColor: _onSurfaceColor,
        textColor: _onSurfaceColor,
        tileColor: _surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return _onSurfaceVariantColor;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryColor;
          }
          return _surfaceVariantColor;
        }),
      ),
      
      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryColor;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: const BorderSide(
          color: _onSurfaceVariantColor,
          width: 2,
        ),
      ),
      
      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryColor;
          }
          return _onSurfaceVariantColor;
        }),
      ),
    );
  }
} 