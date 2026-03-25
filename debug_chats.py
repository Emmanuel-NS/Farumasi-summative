import re

file_path = 'lib/data/repositories/chat_repository_impl.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

# Replace getAdminChatRoomsStream logic to fetch ALL chats
old_pattern = r"""     return _firestore
        \.collection\('chats'\)
        \.where\('adminId', isEqualTo: adminId\)
        \.snapshots\(\)"""

new_pattern = """     // DEBUG: Fetch all chats to bypass potential adminId mismatches
     return _firestore
        .collection('chats')
        // .where('adminId', isEqualTo: adminId) // Commented out for debugging visibility
        .snapshots()"""

if re.search(old_pattern, text):
    text = re.sub(old_pattern, new_pattern, text)
    
with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
