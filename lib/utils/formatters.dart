import 'translations.dart';

class ScanFormatters {
  static String formatConfidenceLabel(double value, AppLanguage language) {
    if (value >= 0.8) {
      return AppStrings.t(language, 'high');
    } else if (value >= 0.6) {
      return AppStrings.t(language, 'medium');
    } else {
      return AppStrings.t(language, 'low');
    }
  }

  static String formatConfidencePercentage(double value) {
    return '${(value * 100).toStringAsFixed(0)}%';
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}