import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/highlights/highlights_bloc.dart';
import '../screens/reader_screen.dart';
import '../widgets/highlight_filter_chip.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HighlightsBloc>().add(const HighlightsLoaded());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openReader(BuildContext context, String bookId, int highlightId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReaderScreen(bookId: bookId, highlightId: highlightId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quotes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search highlights',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onChanged: (value) {
                context.read<HighlightsBloc>().add(HighlightsSearched(value));
              },
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                HighlightFilterChip(label: 'All', colorHex: null),
                HighlightFilterChip(label: 'Yellow', colorHex: '#F6E58D'),
                HighlightFilterChip(label: 'Green', colorHex: '#A3E4D7'),
                HighlightFilterChip(label: 'Blue', colorHex: '#AED6F1'),
                HighlightFilterChip(label: 'Pink', colorHex: '#F5B7B1'),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<HighlightsBloc, HighlightsState>(
                builder: (context, state) {
                  if (state is HighlightsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is HighlightsError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is! HighlightsLoadedState || state.items.isEmpty) {
                    return const Center(child: Text('No highlights yet.'));
                  }
                  return ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final group = state.items[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(group.book.title, style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          ...group.highlights.map(
                            (highlight) => GestureDetector(
                              onTap: () => _openReader(context, group.book.id, highlight.id),
                              child: GlassHighlightCard(
                                text: highlight.selectedText,
                                colorHex: highlight.colorHex,
                                createdAt: highlight.createdAt,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GlassHighlightCard extends StatelessWidget {
  final String text;
  final String colorHex;
  final int createdAt;

  const GlassHighlightCard({
    super.key,
    required this.text,
    required this.colorHex,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    final color = _fromHex(colorHex);
    final date = DateTime.fromMillisecondsSinceEpoch(createdAt);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(_formatDate(date), style: const TextStyle(fontSize: 12)),
                ),
                const SizedBox(height: 12),
                Text(text, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  Color _fromHex(String hex) {
    final cleaned = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }
}
