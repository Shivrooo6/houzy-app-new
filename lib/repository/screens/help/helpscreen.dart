import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('support_messages');

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Add user message to Firestore
    await _messagesCollection.add({
      'sender': 'user',
      'text': text,
      'time': FieldValue.serverTimestamp(),
    });

    _controller.clear();

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessage(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    final isUser = data['sender'] == 'user';

    final Timestamp? timestamp = data['time'] as Timestamp?;
    final time = timestamp != null
        ? DateFormat('hh:mm a').format(timestamp.toDate())
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/bot_avatar.png'),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isUser
                        ? const LinearGradient(
                            colors: [Color(0xFF4facfe), Color(0xFF00f2fe)])
                        : null,
                    color: isUser ? null : const Color(0xFFEFEFEF),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 0),
                      bottomRight: Radius.circular(isUser ? 0 : 16),
                    ),
                  ),
                  child: Text(
                    data['text'] ?? '',
                    style: TextStyle(color: isUser ? Colors.white : Colors.black87),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                )
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isUser) const SizedBox(width: 32), // balance spacing
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Support Chat'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection
                  .orderBy('time', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                // Scroll to bottom when new messages come
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: docs.length,
                  itemBuilder: (context, index) => _buildMessage(docs[index]),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
