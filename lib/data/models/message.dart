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
}
