import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

class ReUseApp extends StatelessWidget {
  const ReUseApp({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFEFE9E2);
    const surface = Color(0xFFF7F1EB);
    const textPrimary = Color(0xFF34312E);
    const textSecondary = Color(0xFF6E675F);
    const pink = Color(0xFFD08A7D);
    const sage = Color(0xFF9DA087);
    const border = Color(0xFFE2D7CA);

    final base = GoogleFonts.manropeTextTheme();

    final scheme = const ColorScheme.light(
      primary: pink,
      secondary: sage,
      surface: surface,
      onSurface: textPrimary,
      outline: border,
      outlineVariant: Color(0xFFE9DED2),
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
            height: 1.42,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
          bodyMedium: GoogleFonts.manrope(
            fontSize: 13,
            height: 1.4,
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
                return Colors.white;
              }
              return const Color(0xFFF2EBE4);
            }),
            foregroundColor: WidgetStateProperty.all(textPrimary),
            side: WidgetStateProperty.all(
              const BorderSide(color: border, width: 1.15),
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