import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/reader/reader_bloc.dart';

class ReaderSettingsSheet extends StatelessWidget {
  final ReaderReady state;

  const ReaderSettingsSheet({super.key, required this.state});

  static const _fonts = ['Merriweather', 'Georgia', 'Roboto'];

  @override
  Widget build(BuildContext context) {
    final settings = state.typographySettings;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reading Settings', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _slider(
            label: 'Font Size',
            value: settings.fontSize,
            min: 14,
            max: 26,
            onChanged: (value) => _updateSettings(context, settings.copyWith(fontSize: value)),
          ),
          _slider(
            label: 'Line Height',
            value: settings.lineHeight,
            min: 1.2,
            max: 2.0,
            onChanged: (value) => _updateSettings(context, settings.copyWith(lineHeight: value)),
          ),
          _slider(
            label: 'Paragraph Spacing',
            value: settings.paragraphSpacing,
            min: 4,
            max: 24,
            onChanged: (value) => _updateSettings(context, settings.copyWith(paragraphSpacing: value)),
          ),
          const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: settings.fontFamily,
            items: _fonts
                .map((font) => DropdownMenuItem(value: font, child: Text(font)))
                .toList(),
            onChanged: (font) {
              if (font == null) return;
              _updateSettings(context, settings.copyWith(fontFamily: font));
            },
            decoration: const InputDecoration(labelText: 'Font Family'),
          ),
          const SizedBox(height: 16),
          Text('Theme', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _themeChip(context, 'light', 'Light'),
              _themeChip(context, 'sepia', 'Sepia'),
              _themeChip(context, 'dark', 'Dark'),
            ],
          ),
          const SizedBox(height: 16),
          Text('Highlights', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (state.highlights.isEmpty)
            const Text('No highlights yet.')
          else
            ...state.highlights.take(5).map((highlight) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        highlight.selectedText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _colorDot(context, highlight.id, '#F6E58D'),
                    _colorDot(context, highlight.id, '#A3E4D7'),
                    _colorDot(context, highlight.id, '#AED6F1'),
                    _colorDot(context, highlight.id, '#F5B7B1'),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => context
                          .read<ReaderBloc>()
                          .add(ReaderHighlightDeleted(highlight.id)),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _slider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }

  Widget _themeChip(BuildContext context, String value, String label) {
    final selected = state.themeMode == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        context.read<ReaderBloc>().add(ReaderThemeChanged(value));
      },
    );
  }

  Widget _colorDot(BuildContext context, int highlightId, String hex) {
    final color = _fromHex(hex);
    return GestureDetector(
      onTap: () => context
          .read<ReaderBloc>()
          .add(ReaderHighlightColorChanged(highlightId, hex)),
      child: Container(
        width: 20,
        height: 20,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12),
        ),
      ),
    );
  }

  void _updateSettings(BuildContext context, TypographySettings settings) {
    context.read<ReaderBloc>().add(
          ReaderSettingsChanged(
            fontSize: settings.fontSize,
            lineHeight: settings.lineHeight,
            fontFamily: settings.fontFamily,
            paragraphSpacing: settings.paragraphSpacing,
          ),
        );
  }

  Color _fromHex(String hex) {
    final cleaned = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }
}
