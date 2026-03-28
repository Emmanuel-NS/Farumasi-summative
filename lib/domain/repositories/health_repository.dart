import '../entities/health_article.dart';

abstract class HealthRepository {
  Future<List<HealthArticle>> getArticles();
  Stream<List<HealthArticle>> getArticlesStream();
  Future<void> addArticle(HealthArticle article);
  Future<void> updateArticle(HealthArticle article);
  Future<void> deleteArticle(String id);
}
