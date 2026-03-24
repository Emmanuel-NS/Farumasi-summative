import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../dummy_data.dart';
import '../../domain/entities/health_article.dart';
import '../models/models.dart'; // Ensures Medicine and HealthArticle are available

class DataSeeder {
  static Future<void> seedData() async {
    final firestore = FirebaseFirestore.instance;

    // --- 1. Seed Medicines ---
    try {
      final medicinesRef = firestore.collection('medicines');
      // Check if collection is empty to avoid overwriting existing data or duplicating work
      final medicinesSnapshot = await medicinesRef.limit(1).get();

      if (medicinesSnapshot.docs.isEmpty) {
        debugPrint('Scaling DB: Seeding Medicines...');
        for (var medicine in dummyMedicines) {
          await medicinesRef.doc(medicine.id).set(medicine.toJson());
        }
        debugPrint('Scaling DB: Medicines Seeded Successfully.');
      } else {
        debugPrint('Scaling DB: Medicines already exist. Skipping seed.');
      }
    } catch (e) {
      debugPrint("Error seeding medicines: $e");
    }

    // --- 2. Seed Health Articles ---
    try {
      final articlesRef = firestore.collection('health_tips');
      final articlesSnapshot = await articlesRef.limit(1).get();

      if (articlesSnapshot.docs.isEmpty) {
        debugPrint('Scaling DB: Seeding Health Articles...');
        for (var article in dummyHealthArticles) {
          // Manually map domain entity to JSON
          await articlesRef.doc(article.id).set(_healthArticleToMap(article));
        }
        debugPrint('Scaling DB: Health Articles Seeded Successfully.');
      } else {
        debugPrint('Scaling DB: Health Articles already exist. Skipping seed.');
      }
    } catch (e) {
      debugPrint("Error seeding health articles: $e");
    }
  }

  static Map<String, dynamic> _healthArticleToMap(HealthArticle article) {
    return {
      'id': article.id,
      'title': article.title,
      'subtitle': article.subtitle,
      'summary': article.summary,
      'fullContent': article.fullContent,
      'category': article.category,
      'readTimeMin': article.readTimeMin,
      'imageUrl': article.imageUrl,
      'source': article.source,
      // Store enum as string (e.g., 'tip', 'news') or handle specifically
      'type': article.type.toString().split('.').last, 
    };
  }
}
