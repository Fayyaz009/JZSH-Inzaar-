import '../../domain/entities/highlight.dart';
import '../../domain/repositories/highlight_repository.dart';
import '../datasources/highlight_local_data_source.dart';
import '../models/highlight_model.dart';

class HighlightRepositoryImpl implements HighlightRepository {
  HighlightRepositoryImpl(this.dataSource);

  final HighlightLocalDataSource dataSource;

  @override
  Future<int> addHighlight(Highlight highlight) async {
    final model = HighlightModel(
      id: 0,
      bookId: highlight.bookId,
      startIndex: highlight.startIndex,
      endIndex: highlight.endIndex,
      selectedText: highlight.selectedText,
      colorHex: highlight.colorHex,
      createdAt: highlight.createdAt,
      note: highlight.note,
    );
    return dataSource.addHighlight(model);
  }

  @override
  Future<void> deleteHighlight(int id) async {
    await dataSource.deleteHighlight(id);
  }

  @override
  Future<Highlight?> getHighlight(int id) async {
    return dataSource.getHighlight(id);
  }

  @override
  Future<List<Highlight>> getHighlights({String? bookId}) async {
    return dataSource.getHighlights(bookId: bookId);
  }

  @override
  Future<void> updateHighlight(Highlight highlight) async {
    final model = HighlightModel(
      id: highlight.id,
      bookId: highlight.bookId,
      startIndex: highlight.startIndex,
      endIndex: highlight.endIndex,
      selectedText: highlight.selectedText,
      colorHex: highlight.colorHex,
      createdAt: highlight.createdAt,
      note: highlight.note,
    );
    await dataSource.updateHighlight(model);
  }
}
