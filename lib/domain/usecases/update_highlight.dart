import '../entities/highlight.dart';
import '../repositories/highlight_repository.dart';

class UpdateHighlight {
  UpdateHighlight(this.repository);

  final HighlightRepository repository;

  Future<int> add(Highlight highlight) => repository.addHighlight(highlight);

  Future<void> update(Highlight highlight) => repository.updateHighlight(highlight);

  Future<void> delete(int id) => repository.deleteHighlight(id);

  Future<Highlight?> get(int id) => repository.getHighlight(id);
}
