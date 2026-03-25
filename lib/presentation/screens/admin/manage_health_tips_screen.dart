import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/health_article.dart';
import '../../blocs/health_tips/health_tips_bloc.dart';
import '../../blocs/health_tips/health_tips_event.dart';
import '../../blocs/health_tips/health_tips_state.dart';
import 'add_edit_health_tip_screen.dart';

class ManageHealthTipsScreen extends StatelessWidget {
  const ManageHealthTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3, child: _ManageHealthTipsView());
  }
}

class _ManageHealthTipsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      floatingActionButton: Builder(
        builder: (ctx) => FloatingActionButton(
          // Use ctx to access Bloc
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddEditHealthTipScreen()),
            );
            // If added, refresh list
            if (result == true) {
              ctx.read<HealthTipsBloc>().add(LoadHealthTips());
            } else {
              ctx.read<HealthTipsBloc>().add(LoadHealthTips());
            }
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),
      body: BlocBuilder<HealthTipsBloc, HealthTipsState>(
        builder: (context, state) {
          if (state is HealthTipsLoading && state is! HealthTipsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HealthTipsError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          List<HealthArticle> allArticles = [];
          if (state is HealthTipsLoaded) {
            allArticles = state.allArticles;
          }

          final tips = allArticles
              .where((a) => a.type == HealthArticleType.tip)
              .toList();
          final remedies = allArticles
              .where((a) => a.type == HealthArticleType.remedy)
              .toList();
          final facts = allArticles
              .where((a) => a.type == HealthArticleType.didYouKnow)
              .toList();

          return TabBarView(
            children: [
              _buildList(context, tips),
              _buildList(context, remedies),
              _buildList(context, facts),
            ],
          );
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, List<HealthArticle> articles) {
    if (articles.isEmpty) {
      return Center(
        child: Text(
          "No articles found.",
          style: TextStyle(color: Colors.grey[500]),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: articles.length,
      itemBuilder: (ctx, i) {
        final article = articles[i];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: article.imageUrl.isNotEmpty
                  ? Image.network(
                      article.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.article, color: Colors.grey),
                    ),
            ),
            title: Text(
              article.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  article.category,
                  style: TextStyle(fontSize: 12, color: Colors.green.shade700),
                ),
                Text(
                  article.summary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AddEditHealthTipScreen(article: article),
                      ),
                    );
                    if (result == true || result == null) {
                      context.read<HealthTipsBloc>().add(LoadHealthTips());
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _confirmDelete(context, article);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, HealthArticle article) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        // ctx here is dialog context
        title: const Text("Confirm Delete"),
        content: Text("Delete '${article.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<HealthTipsBloc>().add(
                DeleteHealthTip(article.id),
              ); // Use context from outer build
              Navigator.pop(ctx);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
