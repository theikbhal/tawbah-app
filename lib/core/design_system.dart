import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF064E3B); // Emerald Green
  static const Color secondary = Color(0xFFD4AF37); // Gold
  static const Color background = Color(0xFFF9FAFB); // Soft White
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF111827); // Deep Slate
  static const Color textSecondary = Color(0xFF6B7280); // Gray
  static const Color accent = Color(0xFF10B981); // Bright Green
  static const Color glass = Color(0x33FFFFFF);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.background,
    ),
    textTheme: GoogleFonts.outfitTextTheme().copyWith(
      displayLarge: GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.outfit(
        fontSize: 16,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
  );
}

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.8),
        borderRadius: borderRadius ?? BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
