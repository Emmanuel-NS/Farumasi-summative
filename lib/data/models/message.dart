import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final bool isMe;
  final String? attachmentPath;
  final String? attachmentType; // 'image', 'file'

  Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.isMe,
    this.attachmentPath,
    this.attachmentType,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'attachmentPath': attachmentPath,
      'attachmentType': attachmentType,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map, String docId, String currentUserId) {
    return Message(
      id: docId,
      senderId: map['senderId'] ?? '',
      content: map['content'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isMe: map['senderId'] == currentUserId,
      attachmentPath: map['attachmentPath'],
      attachmentType: map['attachmentType'],
    );
  }
}
