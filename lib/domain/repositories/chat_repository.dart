import 'package:farumasi_patient_app/data/models/message.dart';

abstract class ChatRepository {
  Stream<List<Message>> getMessagesStream(String roomId, String currentUserId);
  Future<void> sendMessage(String roomId, Message message, {String? patientId, String? adminId});
  Future<void> deleteMessage(String roomId, String messageId);
  String getRoomId(String userId, String adminId);
  Stream<List<Map<String, dynamic>>> getAdminChatRoomsStream(String adminId);
}
