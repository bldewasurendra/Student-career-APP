import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/app_colors.dart';
import '../../services/firebase_service.dart';

class ChatReplyScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const ChatReplyScreen({super.key, required this.userId, required this.userName});

  @override
  State<ChatReplyScreen> createState() => _ChatReplyScreenState();
}

class _ChatReplyScreenState extends State<ChatReplyScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  void _sendReply() async {
    if (_messageController.text.trim().isEmpty) return;
    
    final msg = _messageController.text.trim();
    _messageController.clear();
    
    await _firebaseService.sendAdminReply(widget.userId, msg);
  }

  void _deleteMessage(String msgId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('messages')
        .doc(msgId)
        .delete();
  }

  void _editMessage(String msgId, String currentText) {
    _messageController.text = currentText;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text("Edit Message", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _messageController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: "Enter new text", hintStyle: TextStyle(color: Colors.white24)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.userId)
                  .collection('messages')
                  .doc(msgId)
                  .update({'text': _messageController.text.trim()});
              Navigator.pop(context);
              _messageController.clear();
            }, 
            child: const Text("Save", style: TextStyle(color: AppColors.primary))
          ),
        ],
      ),
    );
  }

  void _showOptions(String msgId, String text, bool isMe) {
    if (!isMe) return; // Only edit/delete own messages
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.white70),
            title: const Text("Edit Message", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _editMessage(msgId, text);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.redAccent),
            title: const Text("Delete Message", style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              Navigator.pop(context);
              _deleteMessage(msgId);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Chat with ${widget.userName}"),
        backgroundColor: AppColors.surface,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firebaseService.getMessages(widget.userId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                final messages = snapshot.data!.docs;
                
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(20),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index].data() as Map<String, dynamic>;
                    final bool isAdmin = msg['isAdmin'] == true;
                    
                    return Align(
                      alignment: isAdmin ? Alignment.centerRight : Alignment.centerLeft,
                      child: GestureDetector(
                        onLongPress: () => _showOptions(messages[index].id, msg['text'] ?? '', isAdmin),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: isAdmin ? AppColors.primary : AppColors.surface,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            msg['text'] ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(15),
      color: AppColors.surface,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Type reply...",
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: _sendReply,
            icon: const Icon(Icons.send, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
