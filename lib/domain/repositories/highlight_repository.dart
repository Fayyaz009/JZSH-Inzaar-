import '../entities/highlight.dart';

abstract class HighlightRepository {
  Future<List<Highlight>> getHighlights({String? bookId});
  Future<int> addHighlight(Highlight highlight);
  Future<void> updateHighlight(Highlight highlight);
  Future<void> deleteHighlight(int id);
  Future<Highlight?> getHighlight(int id);
}
