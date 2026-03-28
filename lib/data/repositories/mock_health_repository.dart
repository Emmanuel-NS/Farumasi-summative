import 'dart:async';
import 'package:farumasi_patient_app/domain/entities/health_article.dart';
import 'package:farumasi_patient_app/domain/repositories/health_repository.dart';
import 'package:farumasi_patient_app/data/dummy_data.dart';

class MockHealthRepository implements HealthRepository {
  List<HealthArticle> _articles = List.from(dummyHealthArticles);
  final StreamController<List<HealthArticle>> _controller = StreamController<List<HealthArticle>>.broadcast();

  MockHealthRepository() {
    _controller.add(_articles);
  }

  void _notify() {
    _controller.add(List.from(_articles));
  }

  @override
  Future<List<HealthArticle>> getArticles() async {
    return _articles;
  }

  @override
  Stream<List<HealthArticle>> getArticlesStream() {
    final controller = StreamController<List<HealthArticle>>();
    controller.add(List.from(_articles));
    controller.addStream(_controller.stream);
    return controller.stream;
  }

  @override
  Future<void> addArticle(HealthArticle article) async {
    _articles.add(article);
    _notify();
  }

  @override
  Future<void> updateArticle(HealthArticle article) async {
    final index = _articles.indexWhere((a) => a.id == article.id);
    if (index != -1) {
      _articles[index] = article;
      _notify();
    }
  }

  @override
  Future<void> deleteArticle(String id) async {
    _articles.removeWhere((a) => a.id == id);
    _notify();
  }
}
