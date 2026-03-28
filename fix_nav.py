import re

with open("lib/presentation/screens/home_screen.dart", "r", encoding="utf-8") as f:
    content = f.read()

# Replace the floating action button and bottom app bar with CurvedNavigationBar
pattern = r"floatingActionButton: ScaleTransition\([\s\S]+?\}\n\}"
replacement = """\
        bottomNavigationBar: SizeTransition(
          sizeFactor: _hideBottomBarController,
          axisAlignment: -1.0,
          child: ListenableBuilder(
            listenable: StateService(),
            builder: (context, _) {
              final isLoggedIn = StateService().isLoggedIn;
              return CurvedNavigationBar(
                index: _currentIndex,
                height: 60.0,
                color: Colors.green,
                buttonBackgroundColor: Colors.white,
                backgroundColor: Colors.transparent, // Figma styling: curved bar over content
                animationCurve: Curves.easeInOut,
                animationDuration: const Duration(milliseconds: 300),
                items: <Widget>[
                  Icon(Icons.store, size: 30, color: _currentIndex == 0 ? Colors.green : Colors.white),
                  Icon(Icons.health_and_safety, size: 30, color: _currentIndex == 1 ? Colors.green : Colors.white),
                  Icon(Icons.document_scanner_outlined, size: 30, color: _currentIndex == 2 ? Colors.green : Colors.white), // Upload Rx
                  Icon(Icons.chat_bubble_outline, size: 30, color: _currentIndex == 3 ? Colors.green : Colors.white),
                  Icon(Icons.history, size: 30, color: _currentIndex == 4 ? Colors.green : Colors.white),
                ],
                onTap: (index) {
                  // Index 2 is Upload Rx, 3 is Consult/Chat, 4 is Orders
                  bool restricted = (index == 2 || index == 3 || index == 4) && !isLoggedIn;
                  if (restricted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Please log in to access this feature."),
                        action: SnackBarAction(
                          label: "Login",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AuthScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                    setState(() {
                      _currentIndex = 0;
                    });
                    return;
                  }
                  setState(() {
                    _currentIndex = index;
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }
}"""
content = re.sub(pattern, replacement, content)

with open("lib/presentation/screens/home_screen.dart", "w", encoding="utf-8") as f:
    f.write(content)
