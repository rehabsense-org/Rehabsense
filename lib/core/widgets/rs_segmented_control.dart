import 'package:flutter/material.dart';
import '../tokens.dart';

class RSSegmentedControl extends StatelessWidget {
  final List<String> segments;
  final int selectedIndex;
  final ValueChanged<int> onValueChanged;

  const RSSegmentedControl({
    super.key,
    required this.segments,
    required this.selectedIndex,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: RSColors.surfaceCeramic,
        borderRadius: BorderRadius.circular(RSRadius.pill),
      ),
      child: Row(
        children: List.generate(segments.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onValueChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? RSColors.brandAction : Colors.transparent,
                  borderRadius: BorderRadius.circular(RSRadius.pill),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  segments[index],
                  style: RSText.bodySmallStrong.copyWith(
                    color: isSelected
                        ? RSColors.textOnDark
                        : RSColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
