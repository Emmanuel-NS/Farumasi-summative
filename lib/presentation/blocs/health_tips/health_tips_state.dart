import 'package:equatable/equatable.dart';
import '../../../domain/entities/health_article.dart';

abstract class HealthTipsState extends Equatable {
  const HealthTipsState();

  @override
  List<Object?> get props => [];
}

class HealthTipsInitial extends HealthTipsState {}

class HealthTipsLoading extends HealthTipsState {}

class HealthTipsLoaded extends HealthTipsState {
  final List<HealthArticle> allArticles;
  final List<HealthArticle> filteredArticles;
  
  const HealthTipsLoaded(this.allArticles, {this.filteredArticles = const []});

  @override
  List<Object?> get props => [allArticles, filteredArticles];
}

class HealthTipsError extends HealthTipsState {
  final String message;
  const HealthTipsError(this.message);
  @override
  List<Object?> get props => [message];
}

class HealthTipsOperationSuccess extends HealthTipsState {
  const HealthTipsOperationSuccess();
}
