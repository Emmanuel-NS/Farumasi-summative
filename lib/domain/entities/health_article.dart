import 'package:equatable/equatable.dart';

enum HealthArticleType { tip, remedy, didYouKnow }

class HealthArticle extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String summary;
  final String fullContent;
  final String imageUrl;
  final String source;
  final String category;
  final HealthArticleType type;
  final int readTimeMin;

  const HealthArticle({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.summary,
    required this.fullContent,
    required this.imageUrl,
    required this.source,
    required this.category,
    this.type = HealthArticleType.tip,
    this.readTimeMin = 5,
  });

  @override
  List<Object?> get props => [
    id, title, subtitle, summary, fullContent, 
    imageUrl, source, category, type, readTimeMin
  ];
}
