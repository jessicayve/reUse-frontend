import 'package:flutter/material.dart';

class AnalysisSummaryCard extends StatelessWidget {
  final String title;
  final String objectName;
  final String conditionLabel;
  final String conditionValue;
  final String decisionLabel;
  final String decisionValue;
  final String confidenceLabel;
  final double confidence;
  final String confidencePercentage;
  final IconData icon;

  const AnalysisSummaryCard({
    super.key,
    required this.title,
    required this.objectName,
    required this.conditionLabel,
    required this.conditionValue,
    required this.decisionLabel,
    required this.decisionValue,
    required this.confidenceLabel,
    required this.confidence,
    required this.confidencePercentage,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: const Color(0xFFF5F1EB),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF23211E),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF3A3632)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        color: const Color(0xFF211F1C),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        icon,
                        size: 42,
                        color: const Color(0xFFB96557),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        objectName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 17,
                          color: const Color(0xFFF5F1EB),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFF3A3632)),
                const SizedBox(height: 12),
                _InfoLine(
                  label: conditionLabel,
                  value: conditionValue,
                ),
                const SizedBox(height: 10),
                _InfoLine(
                  label: decisionLabel,
                  trailing: _DecisionCapsule(
                    text: decisionValue,
                    percentage: confidencePercentage,
                  ),
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFF3A3632)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      confidenceLabel,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFF5F1EB),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ConfidenceBar(value: confidence),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      confidencePercentage,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFB7B0A8),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? trailing;

  const _InfoLine({
    required this.label,
    this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: const Color(0xFFB7B0A8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (value != null)
          Text(
            value!,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFFF5F1EB),
            ),
          ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _DecisionCapsule extends StatelessWidget {
  final String text;
  final String percentage;

  const _DecisionCapsule({
    required this.text,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFFB96557),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: const BoxDecoration(
              color: Color(0xFF8E4A40),
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(999),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              percentage,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfidenceBar extends StatelessWidget {
  final double value;

  const _ConfidenceBar({required this.value});

  @override
  Widget build(BuildContext context) {
    final safeValue = value.clamp(0.0, 1.0);

    return Container(
      height: 12,
      decoration: BoxDecoration(
        color: const Color(0xFF211F1C),
        borderRadius: BorderRadius.circular(999),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                width: constraints.maxWidth * safeValue,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF5F6F57),
                      Color(0xFF718169),
                      Color(0xFF8A9A7F),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}