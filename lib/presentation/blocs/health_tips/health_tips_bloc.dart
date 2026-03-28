import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/health_repository.dart';
import '../../../domain/entities/health_article.dart';
import 'health_tips_event.dart';
import 'health_tips_state.dart';

class HealthTipsBloc extends Bloc<HealthTipsEvent, HealthTipsState> {
  final HealthRepository healthRepository;
  StreamSubscription<List<HealthArticle>>? _subscription;

  HealthTipsBloc({required this.healthRepository}) : super(HealthTipsInitial()) {
    on<LoadHealthTips>(_onLoadHealthTips);
    on<FilterHealthTips>(_onFilterHealthTips);
    on<AddHealthTip>(_onAddHealthTip);
    on<UpdateHealthTip>(_onUpdateHealthTip);
    on<DeleteHealthTip>(_onDeleteHealthTip);
    on<_HealthTipsUpdated>(_onHealthTipsUpdated);
    on<_HealthTipsErrorEvent>(_onHealthTipsError);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void _onLoadHealthTips(LoadHealthTips event, Emitter<HealthTipsState> emit) {
    emit(HealthTipsLoading());
    _subscription?.cancel();
    _subscription = healthRepository.getArticlesStream().listen(
      (articles) {
        add(_HealthTipsUpdated(articles));
      },
      onError: (e) {
        add(_HealthTipsErrorEvent(e.toString()));
      }
    );
  }

  void _onHealthTipsUpdated(_HealthTipsUpdated event, Emitter<HealthTipsState> emit) {
    if (state is HealthTipsLoaded) {

      // let's just emit with the old filter parameter or none. 
      // Current HealthTipsBloc behavior resets on stream anyway unless we store query.
      emit(HealthTipsLoaded(event.articles, filteredArticles: event.articles));
    } else {
      emit(HealthTipsLoaded(event.articles, filteredArticles: event.articles));
    }
  }

  void _onHealthTipsError(_HealthTipsErrorEvent event, Emitter<HealthTipsState> emit) {
    emit(HealthTipsError('Failed to load articles: ${event.message}'));
  }

  void _onFilterHealthTips(FilterHealthTips event, Emitter<HealthTipsState> emit) {
    if (state is HealthTipsLoaded) {
      final currentArticles = (state as HealthTipsLoaded).allArticles;
      final filtered = currentArticles.where((article) {
        final query = event.query.toLowerCase();
        return article.title.toLowerCase().contains(query) ||
            article.summary.toLowerCase().contains(query);
      }).toList();
      emit(HealthTipsLoaded(currentArticles, filteredArticles: filtered));    
    }
  }

  Future<void> _onAddHealthTip(AddHealthTip event, Emitter<HealthTipsState> emit) async {
    try {
      await healthRepository.addArticle(event.article);
    } catch (e) {
      emit(HealthTipsError('Failed to add article: $e'));
    }
  }

  Future<void> _onUpdateHealthTip(UpdateHealthTip event, Emitter<HealthTipsState> emit) async {
    try {
      await healthRepository.updateArticle(event.article);
    } catch (e) {
      emit(HealthTipsError('Failed to update article: $e'));
    }
  }

  Future<void> _onDeleteHealthTip(DeleteHealthTip event, Emitter<HealthTipsState> emit) async {
    try {
      await healthRepository.deleteArticle(event.id);
    } catch (e) {
      emit(HealthTipsError('Failed to delete article: $e'));
    }
  }
}

class _HealthTipsUpdated extends HealthTipsEvent {
  final List<HealthArticle> articles;
  const _HealthTipsUpdated(this.articles);
  @override
  List<Object> get props => [articles];
}

class _HealthTipsErrorEvent extends HealthTipsEvent {
  final String message;
  const _HealthTipsErrorEvent(this.message);
  @override
  List<Object> get props => [message];
}
