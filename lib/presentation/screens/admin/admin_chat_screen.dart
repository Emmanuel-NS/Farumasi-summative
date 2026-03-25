import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farumasi_patient_app/domain/repositories/chat_repository.dart';
import 'package:farumasi_patient_app/data/models/message.dart';
import 'package:intl/intl.dart';

class AdminChatScreen extends StatefulWidget {
  final String roomId;
  final String patientId;
  final String? patientName;

  const AdminChatScreen({super.key, required this.roomId, required this.patientId, this.patientName});

  @override
  State<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  late ChatRepository _chatRepository;
  final String _adminId = 'admin_primary';

  @override
  void initState() {
    super.initState();
    _chatRepository = RepositoryProvider.of<ChatRepository>(context);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent, // reversed
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final content = _messageController.text.trim();
    _messageController.clear();

    final message = Message(
      id: '',
      senderId: _adminId,
      content: content,
      timestamp: DateTime.now(),
      isMe: true, // we evaluate isMe using _adminId parameter below
    );

    _chatRepository.sendMessage(widget.roomId, message, patientId: widget.patientId, adminId: _adminId);
    _scrollToBottom();
  }

  void _deleteMessage(String messageId) {
    _chatRepository.deleteMessage(widget.roomId, messageId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patientName ?? ('Chat with ${widget.patientId.length > 5 ? widget.patientId.substring(0, 5) + '...' : widget.patientId}')),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _chatRepository.getMessagesStream(widget.roomId, _adminId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading messages.'));
                }
                
                final messages = snapshot.data ?? [];
                
                return ListView.builder(
                  controller: _scrollController,
                  reverse: true, // Show newest at bottom
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return GestureDetector(
                      onLongPress: message.isMe ? () => _deleteMessage(message.id) : null,
                      child: _buildMessageBubble(message),
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isMe
              ? Colors.green
              : Colors.grey[200] ?? Colors.grey,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: message.isMe ? const Radius.circular(0) : null,
            bottomLeft: !message.isMe ? const Radius.circular(0) : null,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
                 message.content,
                 style: TextStyle(
                   color: message.isMe ? Colors.white : Colors.black87,
                 ),
             ),
            const SizedBox(height: 4),
            Text(
              DateFormat('hh:mm a').format(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: message.isMe ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
           BoxShadow(
             color: Colors.black.withOpacity(0.05),
             blurRadius: 10,
           ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Type reply...',
                  border: InputBorder.none,
                ),
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              onPressed: _sendMessage,
              icon: const Icon(
                Icons.send,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
