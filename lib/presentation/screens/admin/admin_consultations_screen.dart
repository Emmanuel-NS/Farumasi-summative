import 'package:flutter/material.dart';
import 'package:farumasi_patient_app/data/datasources/state_service.dart';
import 'package:farumasi_patient_app/data/models/models.dart';
import 'package:intl/intl.dart';

class AdminConsultationsScreen extends StatelessWidget {
  const AdminConsultationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final consultations = StateService().consultations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultations'),
        backgroundColor: Colors.green, // Branding
        foregroundColor: Colors.white,
      ),
      body: consultations.isEmpty
          ? const Center(child: Text('No active consultations'))
          : ListView.builder(
              itemCount: consultations.length,
              itemBuilder: (context, index) {
                final session = consultations[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade100,
                    child: Text(session.userName[0].toUpperCase()),
                  ),
                  title: Text(session.userName),
                  subtitle: Text("${session.topic} • ${session.messages.isNotEmpty ? session.messages.last.text : 'No messages'}"),
                  trailing: session.unreadCount > 0 
                      ? Badge(label: Text(session.unreadCount.toString()))
                      : Text(DateFormat('HH:mm').format(session.startedAt)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminChatDetailScreen(session: session),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class AdminChatDetailScreen extends StatefulWidget {
  final ConsultationSession session;
  const AdminChatDetailScreen({super.key, required this.session});

  @override
  State<AdminChatDetailScreen> createState() => _AdminChatDetailScreenState();
}

class _AdminChatDetailScreenState extends State<AdminChatDetailScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.session.userName),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.session.messages.length,
              itemBuilder: (context, index) {
                final msg = widget.session.messages[index];
                final isMe = msg.isMe; // Admin is 'Me'
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.green : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg.text, 
                      style: TextStyle(color: isMe ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a reply...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      setState(() {
                        StateService().addMessage(widget.session.id, _controller.text.trim());
                        _controller.clear();
                      });
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}