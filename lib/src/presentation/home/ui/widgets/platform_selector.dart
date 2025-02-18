import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/notifier/main_home_notifier.dart';

class PlatformSelector extends ConsumerWidget {
  const PlatformSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainHomeProvider);
    final notifier = ref.read(mainHomeProvider.notifier);
    if (state.availablePlatforms.isEmpty) return const Text('No Devices Detected');
    // Check if the selectedPlatform is null or not in the availablePlatforms list
    final selectedPlatform = state.availablePlatforms.contains(state.selectedPlatform)
        ? state.selectedPlatform
        : null;
    return DropdownButton<String>(
      hint: const Text('Select Platform'),
      value: selectedPlatform, // Set the currently selected value
      items: state.availablePlatforms.map((platform) {
        return DropdownMenuItem<String>(
          value: platform, // Set the value to the individual platform
          child: Text(platform),
        );
      }).toList(),
      onChanged: (String? selectedPlatform) {
        notifier.selectPlatform(selectedPlatform!);
      },
    );
  }
}
