import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/scan_result.dart';
import '../services/api_service.dart';
import '../utils/formatters.dart';
import '../utils/translations.dart';
import '../widgets/analysis_summary_card.dart';
import '../widgets/image_picker_section.dart';
import '../widgets/language_toggle.dart';
import '../widgets/result_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();

  AppLanguage _language = AppLanguage.en;

  File? _selectedImage;
  Uint8List? _webImageBytes;
  XFile? _pickedXFile;

  ScanResult? _result;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (file == null) return;

      Uint8List? bytes;
      if (kIsWeb) {
        bytes = await file.readAsBytes();
      }

      setState(() {
        _pickedXFile = file;
        _selectedImage = kIsWeb ? null : File(file.path);
        _webImageBytes = bytes;
        _result = null;
        _errorMessage = null;
      });
    } catch (_) {
      setState(() {
        _errorMessage = _language == AppLanguage.pt
            ? 'Falha ao selecionar a imagem.'
            : 'Failed to select image.';
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_pickedXFile == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _result = null;
    });

    try {
      final result = await ApiService.scanImage(_pickedXFile!);
      setState(() {
        _result = result;
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SCAN ERROR: $e');
      }
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _translateObjectName(String value) {
    return BackendTranslator.translateValue(
      value: value,
      language: _language,
      customMap: BackendTranslator.objectPt,
    );
  }

  String _translateCondition(String value) {
    return BackendTranslator.translateValue(
      value: value,
      language: _language,
      customMap: BackendTranslator.conditionPt,
    );
  }

  String _translateDecision(String value) {
    final translated = BackendTranslator.translateValue(
      value: value,
      language: _language,
      customMap: BackendTranslator.decisionPt,
    );
    return ScanFormatters.capitalize(translated);
  }

  String _translateText(String value) {
    return BackendTranslator.translateValue(
      value: value,
      language: _language,
    );
  }

  IconData _iconForObject(String objectName) {
    final normalized = objectName.toLowerCase();
    if (normalized.contains('shirt') || normalized.contains('camis')) {
      return Icons.checkroom_rounded;
    }
    if (normalized.contains('bottle') || normalized.contains('garrafa')) {
      return Icons.local_drink_rounded;
    }
    if (normalized.contains('shoe') || normalized.contains('sapato')) {
      return Icons.hiking_rounded;
    }
    if (normalized.contains('paper') || normalized.contains('papel')) {
      return Icons.description_rounded;
    }
    return Icons.inventory_2_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = (String key) => AppStrings.t(_language, key);

    return Scaffold(
      body: Stack(
        children: [
          const _DecorativeBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 22),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6EFE8),
                      borderRadius: BorderRadius.circular(38),
                      border: Border.all(color: const Color(0xFFF6EFE8)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x16000000),
                          blurRadius: 32,
                          offset: Offset(0, 16),
                        ),
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 8,
                          offset: Offset(-2, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
                          child: Row(
                            children: [
                              const _BrandMark(),
                              const Spacer(),
                              LanguageToggle(
                                selectedLanguage: _language,
                                onChanged: (value) {
                                  setState(() {
                                    _language = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: const Color(0xFFE6DDD3),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 26, 24, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t('subtitle'),
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontSize: 28,
                                  height: 1.22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 22),
                              ImagePickerSection(
                                imageFile: _selectedImage,
                                webImageBytes: _webImageBytes,
                                chooseImageText: t('chooseImage'),
                                takePhotoText: t('takePhoto'),
                                noImageText: _language == AppLanguage.pt
                                    ? 'Envie ou tire uma foto de um item usado.'
                                    : 'Upload or take a photo of a used item.',
                                selectedImageText: t('selectedImage'),
                                imageReadyText: t('imageReady'),
                                onChooseImage: () => _pickImage(ImageSource.gallery),
                                onTakePhoto: () => _pickImage(ImageSource.camera),
                              ),
                              const SizedBox(height: 16),
                              _AnalyzeButton(
                                label: t('analyzeObject'),
                                enabled: _pickedXFile != null && !_isLoading,
                                onTap: _analyzeImage,
                              ),
                              const SizedBox(height: 24),
                              if (_isLoading)
                                const _SoftStateCard(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 28,
                                        height: 28,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: Color(0xFF5F5A55),
                                        ),
                                      ),
                                      SizedBox(height: 14),
                                      Text(
                                        'Analyzing...',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF615C57),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (_errorMessage != null && !_isLoading)
                                _SoftStateCard(
                                  child: Text(
                                    _errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: const Color(0xFF9C5D63),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              if (_result != null && !_isLoading) ...[
                                AnalysisSummaryCard(
                                  title: t('analysisResult'),
                                  objectName: ScanFormatters.capitalize(
                                    _translateObjectName(_result!.objectName),
                                  ),
                                  conditionLabel: t('condition'),
                                  conditionValue: ScanFormatters.capitalize(
                                    _translateCondition(_result!.condition),
                                  ),
                                  decisionLabel: _language == AppLanguage.pt
                                      ? 'Decisão'
                                      : 'Decision',
                                  decisionValue: _translateDecision(_result!.decision),
                                  confidenceLabel: _language == AppLanguage.pt
                                      ? 'Confiança'
                                      : 'Confidence',
                                  confidence: _result!.confidence,
                                  confidencePercentage:
                                      ScanFormatters.formatConfidencePercentage(
                                    _result!.confidence,
                                  ),
                                  icon: _iconForObject(_result!.objectName),
                                ),
                                if (_result!.reuseIdeas.isNotEmpty)
                                  ResultCard(
                                    title: t('reuseIdeas'),
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        final isNarrow = constraints.maxWidth < 520;
                                        final ideas = _result!.reuseIdeas.take(3).toList();

                                        return GridView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: ideas.length,
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: isNarrow ? 1 : 3,
                                            mainAxisSpacing: 12,
                                            crossAxisSpacing: 12,
                                            childAspectRatio: isNarrow ? 2.4 : 0.92,
                                          ),
                                          itemBuilder: (context, index) {
                                            return _IdeaCard(
                                              text: _translateText(ideas[index]),
                                              icon: _ideaIcon(index),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ResultCard(
                                  title: _language == AppLanguage.pt
                                      ? 'Explicação'
                                      : 'Explanation',
                                  child: Text(
                                    _translateText(_result!.reason),
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: const Color(0xFF5F5A55),
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                                if (_result!.recyclingTip.trim().isNotEmpty)
                                  ResultCard(
                                    title: t('recyclingTip'),
                                    child: Text(
                                      _translateText(_result!.recyclingTip),
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        color: const Color(0xFF5F5A55),
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _ideaIcon(int index) {
    switch (index) {
      case 0:
        return Icons.shopping_bag_outlined;
      case 1:
        return Icons.layers_outlined;
      default:
        return Icons.bed_outlined;
    }
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: const Color(0xFFA7AA93),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x15000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.autorenew_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(width: 12),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
            children: [
              TextSpan(
                text: 'Re',
                style: TextStyle(color: Color(0xFF44413D)),
              ),
              TextSpan(
                text: 'Use',
                style: TextStyle(color: Color(0xFFD08D81)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnalyzeButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _AnalyzeButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: IgnorePointer(
        ignoring: !enabled,
        child: Material(
          color: const Color(0xFFD08D81),
          borderRadius: BorderRadius.circular(999),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: double.infinity,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFD59589),
                    Color(0xFFCB8175),
                  ],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IdeaCard extends StatelessWidget {
  final String text;
  final IconData icon;

  const _IdeaCard({
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAF7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF0E8DF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 18,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: const Color(0xFFF3ECE6),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              size: 32,
              color: const Color(0xFFC89A7D),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4C4844),
              height: 1.28,
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftStateCard extends StatelessWidget {
  final Widget child;

  const _SoftStateCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F4EF),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFF0E8DF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}

class _DecorativeBackground extends StatelessWidget {
  const _DecorativeBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF5F2ED),
                  Color(0xFFF1EDE8),
                ],
              ),
            ),
          ),
          Positioned(
            left: -40,
            top: 180,
            child: _blurBlob(
              width: 180,
              height: 260,
              color: const Color(0xFFF1E8DF),
            ),
          ),
          Positioned(
            right: -60,
            top: 140,
            child: _blurBlob(
              width: 190,
              height: 280,
              color: const Color(0xFFF3EDEA),
            ),
          ),
          Positioned(
            left: 18,
            bottom: 100,
            child: _leafGroup(),
          ),
          Positioned(
            right: 14,
            top: 250,
            child: _leafGroup(),
          ),
        ],
      ),
    );
  }

  Widget _blurBlob({
    required double width,
    required double height,
    required Color color,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }

  Widget _leafGroup() {
    return Opacity(
      opacity: 0.45,
      child: Column(
        children: const [
          Icon(Icons.spa_outlined, color: Color(0xFFB8B6A7), size: 28),
          SizedBox(height: 12),
          Icon(Icons.spa_outlined, color: Color(0xFFC9C2B8), size: 22),
        ],
      ),
    );
  }
}