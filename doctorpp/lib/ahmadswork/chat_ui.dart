import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/constantfile.dart';

class ChatMessage {
  final String sender; // "user" or "admin"
  final String text;
  final String time;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.time,
  });
}

class ChatScreen extends StatelessWidget {
  final List<ChatMessage> messages = [
    ChatMessage(sender: "user", text: "Hello Doctor 👋", time: "10:30 AM"),
    ChatMessage(sender: "admin", text: "Hi, how can I help you today?", time: "10:31 AM"),
    ChatMessage(sender: "user", text: "I have constant headaches.", time: "10:32 AM"),
    ChatMessage(sender: "admin", text: "Do you also feel dizziness?", time: "10:33 AM"),
    ChatMessage(sender: "user", text: "Yes, sometimes dizziness too.", time: "10:34 AM"),
    ChatMessage(sender: "admin", text: "Please book an appointment for further checkup.", time: "10:35 AM"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 4,
        backgroundColor: customBlue,
        shadowColor: customBlue.withOpacity(0.4),
        title: Text(
          "Chat with Doctor",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg.sender == "user";

                return Align(
                  alignment:
                  isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isUser ? customBlue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isUser
                              ? customBlue.withOpacity(0.4) // Blue shadow
                              : Colors.black.withOpacity(0.1), // Grey shadow
                          blurRadius: 10,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: isUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.text,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isUser ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg.time,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isUser
                                ? Colors.white70
                                : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Input Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: GoogleFonts.poppins(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: GoogleFonts.poppins(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [customBlue, customBlue.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: customBlue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 24,
                    child: Icon(Icons.send, color: Colors.white),
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
