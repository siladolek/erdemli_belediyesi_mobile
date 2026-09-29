import 'package:flutter/material.dart';

class LiveSupportScreen extends StatelessWidget {
  const LiveSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryNavy = const Color(0xFF1E3A8A);
    final Color primaryTeal = const Color(0xFF008272);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Canlı Destek'),
        backgroundColor: primaryNavy,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMessageBubble('Merhaba, Erdemli Belediyesi Canlı Destek hattına hoş geldiniz. Size nasıl yardımcı olabilirim?', false),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey.shade200, offset: const Offset(0, -2), blurRadius: 4)],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Mesajınızı yazın...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: primaryTeal,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF008272) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: isMe ? Colors.white : Colors.black87, fontSize: 14),
        ),
      ),
    );
  }
}