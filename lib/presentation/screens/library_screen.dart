import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/book.dart';
import '../blocs/library/library_bloc.dart';
import '../screens/reader_screen.dart';
import '../screens/quotes_screen.dart';
import '../widgets/continue_reading_card.dart';
import '../widgets/library_book_tile.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  void _openReader(BuildContext context, String bookId) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ReaderScreen(bookId: bookId)),
    );
  }

  void _openQuotes(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const QuotesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.format_quote_rounded),
            onPressed: () => _openQuotes(context),
          ),
        ],
      ),
      body: BlocBuilder<LibraryBloc, LibraryState>(
        builder: (context, state) {
          if (state is LibraryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LibraryError) {
            return Center(child: Text(state.message));
          }
          if (state is! LibraryLoaded) {
            return const SizedBox.shrink();
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (state.continueItem != null)
                ContinueReadingCard(
                  item: state.continueItem!,
                  onContinue: () => _openReader(context, state.continueItem!.book.id),
                )
              else
                _EmptyContinueCard(),
              const SizedBox(height: 24),
              Text(
                'All Books',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...state.books.map(
                (book) => LibraryBookTile(
                  book: book,
                  onTap: () => _openReader(context, book.id),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyContinueCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No recent book yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text('Open a book to start your premium reading journey.'),
        ],
      ),
    );
  }
}
