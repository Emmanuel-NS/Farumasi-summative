import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/health_article.dart';
import '../../domain/repositories/health_repository.dart';
import '../models/health_article_model.dart';

class HealthRepositoryImpl implements HealthRepository {
  final FirebaseFirestore _firestore;

  HealthRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<HealthArticle>> getArticles() async {
    try {
      final snapshot = await _firestore.collection('health_tips').get();
      return snapshot.docs
          .map((doc) => HealthArticleModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch articles: $e');
    }
  }

  @override  Stream<List<HealthArticle>> getArticlesStream() {
    return _firestore.collection('health_tips').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => HealthArticleModel.fromSnapshot(doc))
          .toList();
    });
  }

  @override  Future<void> addArticle(HealthArticle article) async {
    try {
      // Cast to model to access toJson
      final model = HealthArticleModel(
        id: article.id,
        title: article.title,
        subtitle: article.subtitle,
        summary: article.summary,
        fullContent: article.fullContent,
        imageUrl: article.imageUrl,
        source: article.source,
        category: article.category,
        type: article.type,
        readTimeMin: article.readTimeMin,
      );

        // Use .add() for empty ID, else .doc().set()
        if (article.id.isEmpty) {
          await _firestore.collection('health_tips').add(model.toJson());
        } else {
          await _firestore.collection('health_tips').doc(article.id).set(model.toJson());
        }
    } catch (e) {
      throw Exception('Failed to add article: $e');
    }
  }

  @override
  Future<void> updateArticle(HealthArticle article) async {
    try {
      final model = HealthArticleModel(
        id: article.id,
        title: article.title,
        subtitle: article.subtitle,
        summary: article.summary,
        fullContent: article.fullContent,
        imageUrl: article.imageUrl,
        source: article.source,
        category: article.category,
        type: article.type,
        readTimeMin: article.readTimeMin,
      );
      await _firestore
          .collection('health_tips')
          .doc(article.id)
          .update(model.toJson());
    } catch (e) {
      throw Exception('Failed to update article: $e');
    }
  }

  @override
  Future<void> deleteArticle(String id) async {
    try {
      await _firestore.collection('health_tips').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete article: $e');
    }
  }
}
