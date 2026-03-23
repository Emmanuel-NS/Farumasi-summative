import 'package:equatable/equatable.dart';
import '../../../domain/entities/health_article.dart';

abstract class HealthTipsEvent extends Equatable {
  const HealthTipsEvent();

  @override
  List<Object?> get props => [];
}

class LoadHealthTips extends HealthTipsEvent {}

class AddHealthTip extends HealthTipsEvent {
  final HealthArticle article;
  const AddHealthTip(this.article);
  @override
  List<Object?> get props => [article];
}

class UpdateHealthTip extends HealthTipsEvent {
  final HealthArticle article;
  const UpdateHealthTip(this.article);
  @override
  List<Object?> get props => [article];
}

class DeleteHealthTip extends HealthTipsEvent {
  final String id;
  const DeleteHealthTip(this.id);
  @override
  List<Object?> get props => [id];
}

// Search/Filter could be an event too
class FilterHealthTips extends HealthTipsEvent {
  final String query;
  const FilterHealthTips(this.query);
  @override
  List<Object?> get props => [query];
}
