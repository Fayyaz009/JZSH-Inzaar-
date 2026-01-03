import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/datasources/book_local_data_source.dart';
import 'data/datasources/highlight_local_data_source.dart';
import 'data/datasources/reading_progress_local_data_source.dart';
import 'data/db/app_database.dart';
import 'data/repositories/book_repository_impl.dart';
import 'data/repositories/highlight_repository_impl.dart';
import 'data/repositories/reading_progress_repository_impl.dart';
import 'domain/usecases/get_books.dart';
import 'domain/usecases/get_continue_reading.dart';
import 'domain/usecases/get_highlights.dart';
import 'domain/usecases/load_reader_data.dart';
import 'domain/usecases/save_reading_progress.dart';
import 'domain/usecases/update_highlight.dart';
import 'domain/usecases/update_reader_settings.dart';
import 'presentation/blocs/highlights/highlights_bloc.dart';
import 'presentation/blocs/library/library_bloc.dart';
import 'presentation/blocs/reader/reader_bloc.dart';
import 'presentation/screens/library_screen.dart';

class ReadingApp extends StatelessWidget {
  final AppDatabase database;

  const ReadingApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    final bookDataSource = BookLocalDataSource();
    final progressDataSource = ReadingProgressLocalDataSource(database);
    final highlightDataSource = HighlightLocalDataSource(database);

    final bookRepository = BookRepositoryImpl(bookDataSource);
    final progressRepository = ReadingProgressRepositoryImpl(progressDataSource);
    final highlightRepository = HighlightRepositoryImpl(highlightDataSource);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: bookRepository),
        RepositoryProvider.value(value: progressRepository),
        RepositoryProvider.value(value: highlightRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => LibraryBloc(
              getBooks: GetBooks(bookRepository),
              getContinueReading: GetContinueReading(progressRepository, bookRepository),
            )..add(LoadLibraryRequested()),
          ),
          BlocProvider(
            create: (context) => ReaderBloc(
              loadReaderData: LoadReaderData(
                bookRepository,
                progressRepository,
                highlightRepository,
              ),
              saveReadingProgress: SaveReadingProgress(progressRepository),
              updateReaderSettings: UpdateReaderSettings(progressRepository),
              updateHighlight: UpdateHighlight(highlightRepository),
            ),
          ),
          BlocProvider(
            create: (_) => HighlightsBloc(
              getHighlights: GetHighlights(highlightRepository, bookRepository),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Reading App',
          theme: ThemeData(useMaterial3: true),
          home: const LibraryScreen(),
        ),
      ),
    );
  }
}
