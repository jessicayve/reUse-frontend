import 'package:flutter/material.dart';
import '../utils/translations.dart';

class LanguageToggle extends StatelessWidget {
  final AppLanguage selectedLanguage;
  final ValueChanged<AppLanguage> onChanged;

  const LanguageToggle({
    super.key,
    required this.selectedLanguage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<AppLanguage>(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment<AppLanguage>(
          value: AppLanguage.en,
          label: Text('EN'),
        ),
        ButtonSegment<AppLanguage>(
          value: AppLanguage.pt,
          label: Text('PT'),
        ),
      ],
      selected: {selectedLanguage},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}