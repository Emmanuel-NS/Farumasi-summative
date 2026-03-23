import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/health_article.dart';

class HealthArticleModel extends HealthArticle {
  const HealthArticleModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.summary,
    required super.fullContent,
    required super.imageUrl,
    required super.source,
    required super.category,
    super.type = HealthArticleType.tip,
    super.readTimeMin = 5,
  });

  factory HealthArticleModel.fromJson(Map<String, dynamic> json, String id) {
    return HealthArticleModel(
      id: id,
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      summary: json['summary'] ?? '',
      fullContent: json['fullContent'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      source: json['source'] ?? '',
      category: json['category'] ?? 'General',
      type: _parseType(json['type']),
      readTimeMin: json['readTimeMin'] ?? 5,
    );
  }

  factory HealthArticleModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HealthArticleModel.fromJson(data, doc.id);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'summary': summary,
      'fullContent': fullContent,
      'imageUrl': imageUrl,
      'source': source,
      'category': category,
      'type': type.name, // Store as string
      'readTimeMin': readTimeMin,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  static HealthArticleType _parseType(String? typeStr) {
    if (typeStr == null) return HealthArticleType.tip;
    return HealthArticleType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => HealthArticleType.tip,
    );
  }
}
