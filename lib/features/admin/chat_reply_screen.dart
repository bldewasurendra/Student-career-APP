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
                fillColor: Colors.white.withOpacity(0.05),
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
