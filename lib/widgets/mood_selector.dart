import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MoodSelectorWidget extends StatelessWidget {
  final String selectedMood;
  final Function(String) onMoodSelected;

  const MoodSelectorWidget({
    Key? key,
    required this.selectedMood,
    required this.onMoodSelected,
  }) : super(key: key);

  final List<Map<String, String>> moods = const [
    {'name': 'Semua', 'label': 'Semua Mood', 'icon': '✨'},
    {'name': 'energi', 'label': 'Butuh Energi', 'icon': '⚡'},
    {'name': 'santai', 'label': 'Ingin Santai', 'icon': '☕'},
    {'name': 'manis', 'label': 'Ingin Manis', 'icon': '🍩'},
    {'name': 'segar', 'label': 'Ingin Segar', 'icon': '🍹'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            children: [
              const Icon(Icons.psychology_outlined, color: AppTheme.primaryCoffee, size: 20),
              const SizedBox(width: 8),
              Text(
                'Rekomendasi Suasana Hati',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: moods.length,
            itemBuilder: (context, index) {
              final mood = moods[index];
              final isSelected = selectedMood.toLowerCase() == mood['name']!.toLowerCase();

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: FilterChip(
                  showCheckmark: false,
                  avatar: Text(
                    mood['icon']!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  label: Text(
                    mood['label']!,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.primaryCoffee,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  selected: isSelected,
                  backgroundColor: AppTheme.cardBg,
                  selectedColor: AppTheme.primaryCoffee,
                  side: BorderSide(
                    color: isSelected ? AppTheme.primaryCoffee : AppTheme.borderLight,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onSelected: (_) => onMoodSelected(mood['name']!),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
