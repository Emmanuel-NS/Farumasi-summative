import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/health_repository.dart';
import 'health_tips_event.dart';
import 'health_tips_state.dart';

class HealthTipsBloc extends Bloc<HealthTipsEvent, HealthTipsState> {
  final HealthRepository healthRepository;

  HealthTipsBloc({required this.healthRepository}) : super(HealthTipsInitial()) {
    on<LoadHealthTips>((event, emit) async {
      emit(HealthTipsLoading());
      try {
        final articles = await healthRepository.getArticles();
        emit(HealthTipsLoaded(articles, filteredArticles: articles));
      } catch (e) {
        emit(HealthTipsError('Failed to load articles: $e'));
      }
    });

    on<AddHealthTip>((event, emit) async {
      try {
        await healthRepository.addArticle(event.article);
        add(LoadHealthTips());
      } catch (e) {
        emit(HealthTipsError('Failed to add article: $e'));
      }
    });

    on<UpdateHealthTip>((event, emit) async {
      try {
        await healthRepository.updateArticle(event.article);
        add(LoadHealthTips());
      } catch (e) {
        emit(HealthTipsError('Failed to update article: $e'));
      }
    });

    on<DeleteHealthTip>((event, emit) async {
      try {
        await healthRepository.deleteArticle(event.id);
        add(LoadHealthTips());
      } catch (e) {
        emit(HealthTipsError('Failed to delete article: $e'));
      }
    });
    
    // Filter logic
    on<FilterHealthTips>((event, emit) async {
      if (state is HealthTipsLoaded) {
        final currentArticles = (state as HealthTipsLoaded).allArticles;
        final filtered = currentArticles.where((article) {
          final query = event.query.toLowerCase();
          return article.title.toLowerCase().contains(query) ||
              article.summary.toLowerCase().contains(query);
        }).toList();
        emit(HealthTipsLoaded(currentArticles, filteredArticles: filtered));
      }
    });
  }
}
