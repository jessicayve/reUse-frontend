import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

class ReUseApp extends StatelessWidget {
  const ReUseApp({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF181715);
    const surface = Color(0xFF23211E);
    const textPrimary = Color(0xFFF5F1EB);
    const textSecondary = Color(0xFFB7B0A8);
    const pink = Color(0xFFB96557);
    const sage = Color(0xFF5F6F57);
    const border = Color(0xFF3A3632);

    final base = GoogleFonts.manropeTextTheme();

    final scheme = const ColorScheme.dark(
      primary: pink,
      secondary: sage,
      surface: surface,
      onSurface: textPrimary,
      outline: border,
      outlineVariant: Color(0xFF312D29),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReUse',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: bg,
        textTheme: base.copyWith(
          headlineLarge: GoogleFonts.manrope(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.2,
            height: 1.05,
            color: textPrimary,
          ),
          headlineMedium: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.9,
            height: 1.18,
            color: textPrimary,
          ),
          titleLarge: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
            color: textPrimary,
          ),
          titleMedium: GoogleFonts.manrope(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
          bodyLarge: GoogleFonts.manrope(
            fontSize: 14,
            height: 1.5,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
          bodyMedium: GoogleFonts.manrope(
            fontSize: 13,
            height: 1.45,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
          labelLarge: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          labelMedium: GoogleFonts.manrope(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
            color: textSecondary,
          ),
        ),
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const Color(0xFF2F2B28);
              }
              return const Color(0xFF211F1C);
            }),
            foregroundColor: WidgetStateProperty.all(textPrimary),
            side: WidgetStateProperty.all(
              const BorderSide(color: border, width: 1.1),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            textStyle: WidgetStateProperty.all(
              GoogleFonts.manrope(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}