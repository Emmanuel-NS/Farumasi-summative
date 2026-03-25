import re

with open('lib/presentation/screens/admin/admin_dashboard_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Remove AnimatedBuilder(animation: StateService()) which causes infinite redraw loop
animated_build_pattern = r"""    return AnimatedBuilder\(
      animation: StateService\(\),
      builder: \(context, child\) \{
        return Scaffold\("""
scaffold_repl = "    return Scaffold("

if re.search(animated_build_pattern, text):
    text = re.sub(animated_build_pattern, scaffold_repl, text, count=1)
    
    # We need to remove the matching closing braces for AnimatedBuilder
    # It finishes at the end of the `Widget build` method for AdminDashboardScreen
    animated_close_pattern = r"""          backgroundColor: Colors\.grey\[50\], // Lighter background
        \);
      \},
    \);
  \}"""
    animated_close_repl = """          backgroundColor: Colors.grey[50], // Lighter background
    );
  }"""
    text = re.sub(animated_close_pattern, animated_close_repl, text, count=1)


# 2. Refactor DashboardOverview to StatefulWidget to cache Streams
dash_overview_pattern = r"""class DashboardOverview extends StatelessWidget \{
  const DashboardOverview\(\{super\.key\}\);

  @override
  Widget build\(BuildContext context\) \{
    return StreamBuilder<QuerySnapshot>\(
      stream: FirebaseFirestore\.instance\.collection\('orders'\)\.snapshots\(\),
      builder: \(context, ordersSnap\) \{
        return StreamBuilder<QuerySnapshot>\(
          stream: FirebaseFirestore\.instance\.collection\('users'\)\.snapshots\(\),
          builder: \(context, usersSnap\) \{"""

dash_overview_repl = """class DashboardOverview extends StatefulWidget {
  const DashboardOverview({super.key});

  @override
  State<DashboardOverview> createState() => _DashboardOverviewState();
}

class _DashboardOverviewState extends State<DashboardOverview> {
  late final Stream<QuerySnapshot> _ordersStream;
  late final Stream<QuerySnapshot> _usersStream;

  @override
  void initState() {
    super.initState();
    _ordersStream = FirebaseFirestore.instance.collection('orders').snapshots();
    _usersStream = FirebaseFirestore.instance.collection('users').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _ordersStream,
      builder: (context, ordersSnap) {
        return StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder: (context, usersSnap) {"""

text = re.sub(dash_overview_pattern, dash_overview_repl, text, count=1)


# 3. Refactor ManageAppUsersScreen to cache Stream in initState
users_stream_pattern = r"""          Expanded\(
            child: StreamBuilder<QuerySnapshot>\(
              stream: FirebaseFirestore\.instance\.collection\('users'\)\.snapshots\(\),"""

users_stream_repl = """          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _usersStream,"""

# We also need to add initState to _ManageAppUsersScreenState
users_state_pattern = r"""class _ManageAppUsersScreenState extends State<ManageAppUsersScreen> \{
  @override
  Widget build\(BuildContext context\) \{"""

users_state_repl = """class _ManageAppUsersScreenState extends State<ManageAppUsersScreen> {
  late final Stream<QuerySnapshot> _usersStream;

  @override
  void initState() {
    super.initState();
    _usersStream = FirebaseFirestore.instance.collection('users').snapshots();
  }

  @override
  Widget build(BuildContext context) {"""

text = re.sub(users_state_pattern, users_state_repl, text, count=1)
text = re.sub(users_stream_pattern, users_stream_repl, text, count=1)


with open('lib/presentation/screens/admin/admin_dashboard_screen.dart', 'w', encoding='utf-8') as f:
    f.write(text)
