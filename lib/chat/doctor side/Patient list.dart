import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant/constantfile.dart';
import '../Contollers/Doc_Chat_Controller.dart';
import 'docchatscreen.dart';

class DoctorAppointmentsScreen extends StatelessWidget {
  final DoctorChatController controller = Get.put(DoctorChatController());

  DoctorAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "My Patients",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: customBlue,
        elevation: 4,
        shadowColor: customBlue.withOpacity(0.3),
      ),
      body: Obx(() {
        if (controller.appointments.isEmpty) {
          return Center(
            child: Text(
              "No patients found",
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
            ),
          );
        }

        // show latest appointments first
        final reversedAppointments = controller.appointments.reversed.toList();

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: reversedAppointments.length,
          itemBuilder: (context, index) {
            final appointment = reversedAppointments[index];

            return StreamBuilder(
              stream: controller.getMessagesStream(appointment.appointmentId),
              builder: (context, snapshot) {
                String lastMessage = "No messages yet";
                bool hasNewMessage = false;

                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  final raw = snapshot.data!.snapshot.value as Map;
                  final msgs = Map<String, dynamic>.from(raw);

                  final sortedMsgs = msgs.entries.map((e) {
                    final m = Map<String, dynamic>.from(e.value);
                    return {
                      "id": e.key,
                      "text": m["text"] ?? "",
                      "timestamp": DateTime.tryParse(m["timestamp"] ?? "") ??
                          DateTime.now(),
                      "senderId": m["senderId"] ?? "",
                      "seen": m["seen"] ?? false,
                    };
                  }).toList()
                    ..sort((a, b) =>
                        (b["timestamp"] as DateTime)
                            .compareTo(a["timestamp"] as DateTime));

                  if (sortedMsgs.isNotEmpty) {
                    final latest = sortedMsgs.first;
                    lastMessage = latest["text"];

                    // only show notification if latest is from patient & not seen
                    if (latest["senderId"] != controller.doctorId &&
                        latest["seen"] == false) {
                      hasNewMessage = true;
                    }
                  }
                }

                return GestureDetector(
                  onTap: () async {
                    // ✅ Mark messages as seen when doctor opens chat
                    await controller.markMessagesAsSeen(
                      appointment.appointmentId,
                      controller.doctorId,
                    );

                    // then navigate to chat
                    Get.to(() => ChatScreen(
                      appointmentId: appointment.appointmentId,
                      patientName: appointment.patientName,
                      doctorId: controller.doctorId,
                    ));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: customBlue.withOpacity(0.1),
                          child: Icon(Icons.person,
                              size: 28, color: customBlue),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointment.patientName,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lastMessage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (hasNewMessage)
                          Container(
                            decoration: BoxDecoration(
                              color: customBlue,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(Icons.notifications,
                                size: 16, color: Colors.white),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
