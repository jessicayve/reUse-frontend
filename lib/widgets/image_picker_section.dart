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
                        size: 36,
                        color: Color(0xFFD48B80),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        noImageText,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
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
                          color: const Color(0xFF7A746D),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: kIsWeb
                            ? Image.memory(
                                webImageBytes!,
                                width: double.infinity,
                                height: 170,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                imageFile!,
                                width: double.infinity,
                                height: 170,
                                fit: BoxFit.cover,
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
                  icon: Icons.photo_camera_rounded,
                  backgroundColor: const Color(0xFFA6A991),
                  foregroundColor: Colors.white,
                  onTap: onChooseImage,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SoftPillButton(
                  label: takePhotoText,
                  icon: Icons.camera_alt_rounded,
                  backgroundColor: const Color(0xFFF8F4EF),
                  foregroundColor: const Color(0xFF7A746D),
                  borderColor: const Color(0xFFD9CEC2),
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
        color: const Color(0xFFF8F4EF),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFF0E8DF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white,
            blurRadius: 8,
            offset: Offset(-2, -2),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xFFF8F4EF),
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
      ..color = const Color(0xFFD9CEC2)
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
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 1.2)
                : null,
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 10,
                offset: Offset(0, 4),
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