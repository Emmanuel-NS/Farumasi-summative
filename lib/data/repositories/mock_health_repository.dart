import '../../domain/entities/health_article.dart';
import '../../domain/repositories/health_repository.dart';
import '../dummy_data.dart';

class MockHealthRepository implements HealthRepository {
  List<HealthArticle> _articles = List.from(dummyHealthArticles);

  @override
  Future<List<HealthArticle>> getArticles() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _articles;
  }

  @override
  Future<void> addArticle(HealthArticle article) async {
    _articles.add(article);
  }

  @override
  Future<void> updateArticle(HealthArticle article) async {
    final index = _articles.indexWhere((a) => a.id == article.id);
    if (index != -1) {
      _articles[index] = article;
    }
  }

  @override
  Future<void> deleteArticle(String id) async {
    _articles.removeWhere((a) => a.id == id);
  }
}
