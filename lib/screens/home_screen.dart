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
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF23211E),
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(
                        color: const Color(0xFF3A3632),
                        width: 1.2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x30000000),
                          blurRadius: 34,
                          offset: Offset(0, 18),
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
                          color: const Color(0xFF312D29),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 26, 24, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t('subtitle'),
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontSize: 28,
                                  height: 1.22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _language == AppLanguage.pt
                                    ? 'Escaneie um item usado e receba a melhor ação sustentável.'
                                    : 'Scan a used item and get the best sustainable action.',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: const Color(0xFFB7B0A8),
                                  height: 1.55,
                                ),
                              ),
                              const SizedBox(height: 24),
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
                              const SizedBox(height: 18),
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
                                        width: 30,
                                        height: 30,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: Color(0xFFB96557),
                                        ),
                                      ),
                                      SizedBox(height: 14),
                                      Text(
                                        'Analyzing...',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFFD8D1C8),
                                          fontSize: 15,
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
                                      color: const Color(0xFFE58B8B),
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
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: isNarrow ? 1 : 3,
                                            mainAxisSpacing: 12,
                                            crossAxisSpacing: 12,
                                            childAspectRatio: isNarrow ? 2.5 : 0.95,
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
                                      color: const Color(0xFFD8D1C8),
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                                if (_result!.recyclingTip.trim().isNotEmpty)
                                  ResultCard(
                                    title: t('recyclingTip'),
                                    child: Text(
                                      _translateText(_result!.recyclingTip),
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        color: const Color(0xFFD8D1C8),
                                        height: 1.6,
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
            color: const Color(0xFF5F6F57),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 12,
                offset: Offset(0, 6),
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
                style: TextStyle(color: Color(0xFFF5F1EB)),
              ),
              TextSpan(
                text: 'Use',
                style: TextStyle(color: Color(0xFFB96557)),
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
          color: Colors.transparent,
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
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFB96557),
                    Color(0xFF8F473C),
                  ],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 18,
                    offset: Offset(0, 10),
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
                      color: Color(0xFFFFF8F3),
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                      shadows: [
                        Shadow(
                          color: Color(0x66000000),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.search_rounded,
                    color: Color(0xFFFFF8F3),
                    size: 28,
                    shadows: [
                      Shadow(
                        color: Color(0x66000000),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
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
        color: const Color(0xFF2B2825),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3A3632)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 18,
            offset: Offset(0, 8),
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
              color: const Color(0xFF211F1C),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              size: 32,
              color: const Color(0xFFB96557),
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
              color: Color(0xFFF1ECE5),
              height: 1.3,
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
        color: const Color(0xFF2B2825),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF3A3632)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
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
                  Color(0xFF181715),
                  Color(0xFF11100F),
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
              color: const Color(0xFF262320),
            ),
          ),
          Positioned(
            right: -60,
            top: 140,
            child: _blurBlob(
              width: 190,
              height: 280,
              color: const Color(0xFF201D1A),
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
      opacity: 0.22,
      child: Column(
        children: const [
          Icon(Icons.spa_outlined, color: Color(0xFF5F6F57), size: 28),
          SizedBox(height: 12),
          Icon(Icons.spa_outlined, color: Color(0xFF7C866C), size: 22),
        ],
      ),
    );
  }
}