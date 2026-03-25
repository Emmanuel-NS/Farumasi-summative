import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/message.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  String getRoomId(String userId, String adminId) {
    List<String> ids = [userId, adminId];
    ids.sort();
    return ids.join('_');
  }

  @override
  Stream<List<Message>> getMessagesStream(String roomId, String currentUserId) {
    return _firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(100) // Optimization: Only load last 100 messages
        .snapshots()
        .map((snapshot) {
           return snapshot.docs.map((doc) => Message.fromMap(doc.data(), doc.id, currentUserId)).toList();
        });
  }

  @override
  Future<void> sendMessage(String roomId, Message message, {String? patientId, String? adminId}) async {
    // Add extra metadata to surface in admin lists
    Map<String, dynamic> roomData = {
      'lastMessage': message.content,
      'lastUpdated': FieldValue.serverTimestamp(),
      'participants': FieldValue.arrayUnion([message.senderId]),
    };
    if (patientId != null) roomData['patientId'] = patientId;
    if (adminId != null) roomData['adminId'] = adminId;

    await _firestore.collection('chats').doc(roomId).set(roomData, SetOptions(merge: true));

    await _firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .add(message.toMap());
  }

  @override
  Future<void> deleteMessage(String roomId, String messageId) async {
    await _firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }
  
  @override
  Stream<List<Map<String, dynamic>>> getAdminChatRoomsStream(String adminId) {
     return _firestore
        .collection('chats')
        .where('adminId', isEqualTo: adminId)
        .snapshots()
        .map((snapshot) {
          final docs = snapshot.docs.map((doc) {
            final data = doc.data();
            data['roomId'] = doc.id;
            return data;
          }).toList();
          // Sort locally to avoid requiring a Firestore composite index
          docs.sort((a, b) {
            final aTime = a['lastUpdated'] as Timestamp?;
            final bTime = b['lastUpdated'] as Timestamp?;
            if (aTime == null && bTime == null) return 0;
            if (aTime == null) return 1;
            if (bTime == null) return -1;
            return bTime.compareTo(aTime);
          });
          return docs;
        });
  }
}
