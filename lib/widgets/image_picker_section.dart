import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImagePickerSection extends StatelessWidget {
  final File? imageFile;
  final Uint8List? webImageBytes;

  final String chooseImageText;
  final String takePhotoText;
  final String noImageText;
  final String selectedImageText;
  final String imageReadyText;

  final VoidCallback onChooseImage;
  final VoidCallback onTakePhoto;

  const ImagePickerSection({
    super.key,
    required this.imageFile,
    required this.webImageBytes,
    required this.chooseImageText,
    required this.takePhotoText,
    required this.noImageText,
    required this.selectedImageText,
    required this.imageReadyText,
    required this.onChooseImage,
    required this.onTakePhoto,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = kIsWeb ? webImageBytes != null : imageFile != null;

    return _SoftOuterCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        children: [
          _DashedArea(
            child: !hasImage
                ? Column(
                    children: [
                      const Icon(
                        Icons.camera_alt_rounded,
                        size: 38,
                        color: Color(0xFFB96557),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        noImageText,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFF5F1EB),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        imageReadyText,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: const Color(0xFFB7B0A8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF3A3632),
                              width: 1.1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: kIsWeb
                              ? Image.memory(
                                  webImageBytes!,
                                  width: double.infinity,
                                  height: 190,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  imageFile!,
                                  width: double.infinity,
                                  height: 190,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SoftPillButton(
                  label: chooseImageText,
                  icon: Icons.photo_library_rounded,
                  backgroundColor: const Color(0xFF5F6F57),
                  foregroundColor: Colors.white,
                  onTap: onChooseImage,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SoftPillButton(
                  label: takePhotoText,
                  icon: Icons.camera_alt_rounded,
                  backgroundColor: const Color(0xFF211F1C),
                  foregroundColor: const Color(0xFFF5F1EB),
                  borderColor: const Color(0xFF3A3632),
                  onTap: onTakePhoto,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SoftOuterCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _SoftOuterCard({
    required this.child,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF2B2825),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF3A3632),
          width: 1.1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _DashedArea extends StatelessWidget {
  final Widget child;

  const _DashedArea({required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedPainter(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xFF23211E),
        ),
        child: child,
      ),
    );
  }
}

class _DashedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const radius = 24.0;
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(radius),
    );

    final paint = Paint()
      ..color = const Color(0xFF4A443E)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const dashWidth = 6.0;
    const dashSpace = 5.0;

    final path = Path()..addRRect(rect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SoftPillButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const _SoftPillButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 1.2)
                : null,
            boxShadow: const [
              BoxShadow(
                color: Color(0x16000000),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foregroundColor, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foregroundColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}