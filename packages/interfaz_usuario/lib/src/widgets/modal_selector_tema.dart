import 'package:flutter/material.dart';
import '../theme/config_tema.dart';

class ThemeSelectorModal extends StatelessWidget {
  const ThemeSelectorModal({
    super.key,
    required this.currentThemeId,
    required this.availableThemes,
    required this.onThemeSelected,
  });

  final String currentThemeId;
  final List<ThemeConfig> availableThemes;
  final ValueChanged<ThemeConfig> onThemeSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Elige un Estilo',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: availableThemes.length,
            itemBuilder: (context, index) {
              final theme = availableThemes[index];
              final isSelected = theme.id == currentThemeId;
              
              return GestureDetector(
                onTap: () => onThemeSelected(theme),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected 
                      ? Border.all(color: theme.primary, width: 3)
                      : Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: theme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        theme.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.onSurface,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
