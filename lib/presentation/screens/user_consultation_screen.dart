import 'package:flutter/material.dart';
import 'package:farumasi_patient_app/data/datasources/state_service.dart';
import 'package:farumasi_patient_app/data/models/models.dart';
import 'package:farumasi_patient_app/presentation/widgets/farumasi_logo_widget.dart';
import 'package:intl/intl.dart';

class UserConsultationScreen extends StatefulWidget {
  const UserConsultationScreen({super.key});

  @override
  State<UserConsultationScreen> createState() => _UserConsultationScreenState();
}

class _UserConsultationScreenState extends State<UserConsultationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    StateService().sendUserMessage(_messageController.text.trim());
    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FarumasiLogo(size: 32, onDark: true), // Use the Leafy logo
            const SizedBox(width: 8),
            const Text('Consult Pharmacist'),
          ],
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Info Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.green.shade50,
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Our pharmacists are available 24/7. Ask about symptoms, dosage, or prescriptions.",
                    style: TextStyle(color: Colors.green.shade800, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListenableBuilder(
              listenable: StateService(),
              builder: (context, child) {
                // Get the current user's active session
                // We access the getter we created in StateService
                // Note: userConsultation might create a new session if none exists
                // We need to implement that logic in StateService or here
                
                // Since `userConsultation` is a getter that might mutate state (add new session),
                // it is safer to call it once per build or rely on it being idempotent.
                // However, StateService.userConsultation implementation creates a new one if not found.
                // This is fine.
                
                // Wait, StateService doesn't have `userConsultation` getter exposed yet in my previous edit?
                // I added `ConsultationSession get userConsultation`. Yes.
                
                final session = StateService().userConsultation;
                final messages = session.messages;

                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 60, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        const Text("No messages yet.", style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 8),
                        const Text("Start typing to consult a pharmacist.", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                }

                // Auto-scroll to bottom on update
                // But only if we are already near bottom or it's a new message
                // For simplicity, let's keep it manual or call _scrollToBottom in `send`.
                
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    // On User screen:
                    // My messages (senderId == currentUserId / isMe=true from sendUserMessage) -> Right
                    // Admin messages (senderId == 'admin') -> Left
                    
                    // But StateService adds 'admin' messages with isMe=true for Admin view.
                    // And adds user messages with isMe=true for User view?
                    // No.
                    
                    // Let's rely on senderId.
                    // User ID is simulated as "user1" in StateService.
                    // Admin ID is "admin".
                    
                    final isMe = msg.senderId != "admin"; // Simple logic for User View
                    return _buildMessageBubble(msg, isMe);
                  },
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? Colors.green : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(16),
          ),
        ),
        constraints: const BoxConstraints(maxWidth: 260),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(msg.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white70 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type your message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 4,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.green,
            radius: 24,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
