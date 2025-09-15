import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant/constantfile.dart';
import '../Contollers/PatientChatController.dart';

class ChatMessage {
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool seen;

  ChatMessage({
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.seen,
  });
}

class PatientChatScreen extends StatefulWidget {
  final String appointmentId;
  final String patientId; // can use appointmentId if no separate ID
  final String doctorName;

  const PatientChatScreen({
    super.key,
    required this.appointmentId,
    required this.patientId,
    required this.doctorName,
  });

  @override
  State<PatientChatScreen> createState() => _PatientChatScreenState();
}

class _PatientChatScreenState extends State<PatientChatScreen> {
  final PatientChatController controller = Get.put(PatientChatController());
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Future<void> _refreshMessages() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {}); // Firebase updates automatically
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 4,
        backgroundColor: customBlue,
        shadowColor: customBlue.withOpacity(0.4),
        title: Text(
          "Chat with ${widget.doctorName}",
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
          // 🔹 Chat Messages
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshMessages,
              child: StreamBuilder(
                stream: controller.listenToMessages(widget.appointmentId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data!.snapshot.value == null) {
                    return const Center(child: Text("No messages yet"));
                  }

                  final messagesMap = Map<String, dynamic>.from(
                    snapshot.data!.snapshot.value as Map<dynamic, dynamic>,
                  );

                  final messages = messagesMap.entries.map((e) {
                    final m = Map<String, dynamic>.from(e.value);
                    return ChatMessage(
                      senderId: m["senderId"] ?? "",
                      text: m["text"] ?? "",
                      timestamp: DateTime.tryParse(m["timestamp"] ?? "") ??
                          DateTime.now(),
                      seen: m["seen"] ?? false,
                    );
                  }).toList()
                    ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

                  // auto scroll down when new messages arrive
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isPatient = message.senderId == widget.patientId;

                      return Align(
                        alignment: isPatient
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isPatient ? customBlue : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: isPatient
                                    ? customBlue.withOpacity(0.4)
                                    : Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(2, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                message.text,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isPatient ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: isPatient
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                  ),
                                  if (isPatient) ...[
                                    const SizedBox(width: 4),
                                    Icon(
                                      message.seen
                                          ? Icons.done_all
                                          : Icons.done,
                                      size: 16,
                                      color: message.seen
                                          ? Colors.lightBlueAccent
                                          : (isPatient
                                          ? Colors.white70
                                          : Colors.black54),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // 🔹 Input Box
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
                    controller: _textController,
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
                GestureDetector(
                  onTap: () {
                    final text = _textController.text.trim();
                    if (text.isNotEmpty) {
                      controller.sendMessage(
                        appointmentId: widget.appointmentId,
                        senderId: widget.patientId,
                        text: text,
                      );
                      _textController.clear();
                      _scrollToBottom();
                    }
                  },
                  child: Container(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
