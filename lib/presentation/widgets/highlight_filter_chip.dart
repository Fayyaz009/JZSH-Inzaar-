import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/highlights/highlights_bloc.dart';

class HighlightFilterChip extends StatelessWidget {
  final String label;
  final String? colorHex;

  const HighlightFilterChip({super.key, required this.label, required this.colorHex});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HighlightsBloc, HighlightsState>(
      builder: (context, state) {
        final active = state is HighlightsLoadedState && state.activeFilter == colorHex;
        return ChoiceChip(
          label: Text(label),
          selected: active,
          onSelected: (_) {
            context.read<HighlightsBloc>().add(HighlightsFilteredByColor(colorHex));
          },
        );
      },
    );
  }
}
