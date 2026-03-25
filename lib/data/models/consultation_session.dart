import 'chat_message.dart';

class ConsultationSession {
  final String id;
  final String userId;
  final String userName;
  final String topic; // e.g. "General Inquiry", "Prescription Help"
  final DateTime startedAt;
  final List<ChatMessage> messages;
  final bool isActive;
  final int unreadCount;

  ConsultationSession({
    required this.id,
    required this.userId,
    required this.userName,
    required this.topic,
    required this.startedAt,
    this.messages = const [],
    this.isActive = true,
    this.unreadCount = 0,
  });
}
