import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farumasi_patient_app/domain/repositories/chat_repository.dart';
import 'package:farumasi_patient_app/data/models/message.dart';
import 'package:farumasi_patient_app/presentation/screens/admin/admin_chat_screen.dart';
import 'package:intl/intl.dart';

class AdminConsultationsScreen extends StatefulWidget {
  const AdminConsultationsScreen({super.key});

  @override
  State<AdminConsultationsScreen> createState() => _AdminConsultationsScreenState();
}

class _AdminConsultationsScreenState extends State<AdminConsultationsScreen> {
  // Default to false: Oldest First (Ascending) based on user request
  bool _sortNewestFirst = false;

  @override
  Widget build(BuildContext context) {
    // We assume the admin logging in is 'admin_primary' for now.
    final String adminId = 'admin_primary'; 
    final chatRepository = RepositoryProvider.of<ChatRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Consultations'),
        backgroundColor: Colors.green, // Branding
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<bool>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort Conversation',
            initialValue: _sortNewestFirst,
            onSelected: (bool isNewest) {
              setState(() {
                _sortNewestFirst = isNewest;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<bool>>[
              const PopupMenuItem<bool>(
                value: false,
                child: Row(
                  children: [
                    Icon(Icons.history, color: Colors.black54),
                    SizedBox(width: 8),
                    Text('Oldest Activity (Default)'),
                  ],
                ),
              ),
              const PopupMenuItem<bool>(
                value: true,
                child: Row(
                   children: [
                     Icon(Icons.update, color: Colors.black54),
                     SizedBox(width: 8),
                     Text('Newest Activity'),
                   ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatRepository.getAdminChatRoomsStream(adminId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
             debugPrint("Admin Chat Error: ${snapshot.error}");
             return const Center(child: Text('Error loading chats. \nCheck debug logs.'));
          }

          var rooms = snapshot.data ?? [];

          if (rooms.isEmpty) {
            return const Center(child: Text('No active consultations yet.'));
          }
          
          // Apply Sorting
          rooms.sort((a, b) {
             final aTime = (a['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime(2000);
             final bTime = (b['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime(2000);
             
             if (_sortNewestFirst) {
               return bTime.compareTo(aTime); // Descending (Newest Top)
             } else {
               return aTime.compareTo(bTime); // Ascending (Oldest Top)
             }
          });

          return ListView.separated(
            itemCount: rooms.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final room = rooms[index];
              return _ConsultationTile(room: room);
            },
          );
        },
      ),
    );
  }
}

class _ConsultationTile extends StatelessWidget {
  final Map<String, dynamic> room;

  const _ConsultationTile({required this.room});

  @override
  Widget build(BuildContext context) {
    var pid = room['patientId'];
    final String patientId = (pid is String) ? pid : 'Unknown';
    final lastMessage = room['lastMessage'] ?? '';
    final time = (room['lastUpdated'] as Timestamp?)?.toDate();

    // Fetch User Details for the Patient ID
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(patientId).snapshots(),
      builder: (context, userSnap) {
        String displayName = "Loading...";
        if (userSnap.hasData) {
          if (userSnap.data != null && userSnap.data!.exists) {
             final data = userSnap.data!.data() as Map<String, dynamic>?;
             displayName = data?['displayName'] ?? data?['name'] ?? 'Patient';
          } else {
             displayName = "Patient (${patientId.substring(0, min(5, patientId.length))}...)";
          }
        } else if (patientId == 'Unknown') {
          displayName = "Unknown Patient";
        }

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Text(
              (displayName.isNotEmpty && displayName != "Loading...") ? displayName[0].toUpperCase() : '?',
              style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            displayName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              lastMessage,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                 color: Colors.black87,
              ),
            ),
          ),
          trailing: time != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('MMM d').format(time),
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('hh:mm a').format(time),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                )
              : null,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AdminChatScreen(
                  roomId: room['roomId'],
                  patientId: patientId,
                ),
              ),
            );
          },
        );
      }
    );
  }
  
  int min(int a, int b) => a < b ? a : b;
}
