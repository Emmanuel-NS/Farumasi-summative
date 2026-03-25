import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farumasi_patient_app/domain/repositories/chat_repository.dart';
import 'package:farumasi_patient_app/presentation/screens/admin/admin_chat_screen.dart';
import 'package:intl/intl.dart';

class AdminConsultationsScreen extends StatefulWidget {
  const AdminConsultationsScreen({super.key});

  @override
  State<AdminConsultationsScreen> createState() => _AdminConsultationsScreenState();
}

class _AdminConsultationsScreenState extends State<AdminConsultationsScreen> {
  // Default to false: Oldest First (Ascending) based on user request
  bool _sortNewestFirst = true; // Changed to Newest First as requested
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We assume the admin logging in is 'admin_primary' for now.
    final String adminId = 'admin_primary'; 
    final chatRepository = RepositoryProvider.of<ChatRepository>(context);

    // Fetch Chats Stream
    final chatsStream = chatRepository.getAdminChatRoomsStream(adminId);
    
    // Fetch Users Stream (to map names)
    final usersStream = FirebaseFirestore.instance.collection('users').snapshots();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'Search patients...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.white),
          ),
          onChanged: (val) {
            setState(() {
              _searchQuery = val.toLowerCase();
            });
          },
        ),
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
                    Text('Oldest Activity'), // Ascending
                  ],
                ),
              ),
              const PopupMenuItem<bool>(
                value: true,
                child: Row(
                   children: [
                     Icon(Icons.update, color: Colors.black54),
                     SizedBox(width: 8),
                     Text('Newest Activity'), // Descending
                   ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatsStream,
        builder: (context, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (chatSnapshot.hasError) {
             debugPrint("Admin Chat Error: ${chatSnapshot.error}");
             return const Center(child: Text('Error loading chats. \nCheck debug logs.'));
          }

          final chats = chatSnapshot.data ?? [];

          return StreamBuilder<QuerySnapshot>(
            stream: usersStream,
            builder: (context, userSnapshot) {
              // Create Map of User ID -> User Data
              final userMap = <String, Map<String, dynamic>>{};
              if (userSnapshot.hasData) {
                for (var doc in userSnapshot.data!.docs) {
                  userMap[doc.id] = doc.data() as Map<String, dynamic>;
                }
              }

              // Filter
              final filteredChats = chats.where((chat) {
                final pid = chat['patientId'] ?? '';
                final user = userMap[pid];
                
                final name = (user?['displayName'] ?? user?['name'] ?? 'Unknown').toString().toLowerCase();
                final email = (user?['email'] ?? '').toString().toLowerCase();
                final query = _searchQuery; 

                // Check if query matches Name, ID, or Phone/Email
                return name.contains(query) || email.contains(query) || pid.toString().contains(query);
              }).toList();

              // Apply Sort
              filteredChats.sort((a, b) {
                 final aTime = (a['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime(2000);
                 final bTime = (b['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime(2000);
                 
                 if (_sortNewestFirst) {
                   return bTime.compareTo(aTime); // Descending (Newest Top)
                 } else {
                   return aTime.compareTo(bTime); // Ascending (Oldest Top)
                 }
              });

              if (filteredChats.isEmpty) {
                 if (_searchQuery.isNotEmpty) {
                    return const Center(child: Text('No patients found matching query.'));
                 }
                 return const Center(child: Text('No active consultations yet.'));
              }

              return ListView.separated(
                itemCount: filteredChats.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final chat = filteredChats[index];
                  final pid = chat['patientId'] ?? '';
                  final user = userMap[pid]; // Fetch by ID
                  
                  String displayName = "Loading...";
                  if (user != null) {
                    displayName = user['displayName'] ?? user['name'] ?? 'Patient';
                  } else if (pid != 'Unknown') {
                    displayName = "Patient (${pid.toString().substring(0, min(5, pid.toString().length))}...)";
                  } else {
                    displayName = "Unknown Patient";
                  }

                  final lastMessage = chat['lastMessage'] ?? '';
                  final time = (chat['lastUpdated'] as Timestamp?)?.toDate();

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
                        style: const TextStyle(color: Colors.black87),
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
                            roomId: chat['roomId'],
                            patientId: pid,
                            patientName: displayName,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
  
  int min(int a, int b) => a < b ? a : b;
}

