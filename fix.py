import re

with open('lib/presentation/widgets/global_notification_wrapper.dart', 'r', encoding='utf-8') as f:
    data = f.read()

replacement = r'''  void _listenToHealthArticles() async {
    _healthSubscription?.cancel();
    final prefs = await SharedPreferences.getInstance();
    List<String> cachedArticles = prefs.getStringList('known_articles_cache') ?? [];

    _knownArticles.addAll(cachedArticles);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final healthRepo = context.read<HealthRepository>();

      _healthSubscription = healthRepo.getArticlesStream().listen((articles) {
        bool hasChanges = false;

        if (_isFirstLoadArticles) {
          if (cachedArticles.isEmpty) {
            for (var a in articles) {
              _knownArticles.add(a.id);
            }
            hasChanges = true;
          } else {
            for (var a in articles) {
              if (!_knownArticles.contains(a.id)) {
                _knownArticles.add(a.id);
                hasChanges = true;
                _showArticleNotification(a);
              }
            }
          }
          _isFirstLoadArticles = false;
        } else {
          for (var a in articles) {
            if (!_knownArticles.contains(a.id)) {
              _knownArticles.add(a.id);
              hasChanges = true;
              _showArticleNotification(a);
            }
          }
        }

        if (hasChanges) {
          prefs.setStringList('known_articles_cache', _knownArticles.toList());
        }
      });
    });
  }

  void _showArticleNotification(HealthArticle a) {
    String notificationTitle = 'New Health Update ??';
    switch (a.type) {
      case HealthArticleType.tip:
        notificationTitle = 'New Health Tip ??';
        break;
      case HealthArticleType.remedy:
        notificationTitle = 'New Health Remedy ??';
        break;
      case HealthArticleType.didYouKnow:
        notificationTitle = 'Did you know? ??';
        break;
    }

    NotificationService().showNotification(
      id: (DateTime.now().millisecondsSinceEpoch ~/ 1000) + a.id.hashCode,
      title: notificationTitle,
      body: '\\\n\\n\',
      category: 'health_tip',
      payload: a.id,
    );
  }

  void _listenToOrders(String userId) async {'''

result = re.sub(r'  void _listenToHealthArticles\(\) \{.*?void _listenToOrders\(String userId\) async \{', replacement, data, flags=re.DOTALL)

with open('lib/presentation/widgets/global_notification_wrapper.dart', 'w', encoding='utf-8') as f:
    f.write(result)
