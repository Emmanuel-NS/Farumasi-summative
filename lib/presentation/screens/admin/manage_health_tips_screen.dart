import 'package:flutter/material.dart';
import 'package:farumasi_patient_app/data/datasources/state_service.dart';
import 'package:farumasi_patient_app/data/models/models.dart';
import 'add_edit_health_tip_screen.dart';

class ManageHealthTipsScreen extends StatelessWidget {
  const ManageHealthTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Health Tips'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.greenAccent,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "General Tips"),
              Tab(text: "Remedies"),
              Tab(text: "Did You Know?"),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddEditHealthTipScreen()),
            );
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
        body: ListenableBuilder(
          listenable: StateService(),
          builder: (context, _) {
            final allArticles = StateService().healthArticles;
            
            final tips = allArticles.where((a) => a.type == HealthArticleType.tip).toList();
            final remedies = allArticles.where((a) => a.type == HealthArticleType.remedy).toList();
            final facts = allArticles.where((a) => a.type == HealthArticleType.didYouKnow).toList();

            return TabBarView(
              children: [
                _buildList(context, tips),
                _buildList(context, remedies),
                _buildList(context, facts),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<HealthArticle> articles) {
    if (articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text("No content in this category", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: articles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final article = articles[index];
        return ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              article.imageUrl,
              width: 50, height: 50, fit: BoxFit.cover,
              errorBuilder: (_,__,___) => Container(width: 50, height: 50, color: Colors.grey.shade300, child: const Icon(Icons.broken_image, size: 20)),
            ),
          ),
          title: Text(article.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(article.category, style: const TextStyle(fontSize: 12)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddEditHealthTipScreen(article: article)),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // Confirm Dialog
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Delete Post?"),
                      content: const Text("Are you sure you want to remove this post?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            StateService().deleteHealthArticle(article.id);
                            Navigator.pop(ctx);
                          },
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

