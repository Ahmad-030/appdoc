import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
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
          // Shimmer effect while loading
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: 6,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.appointments.length,
          itemBuilder: (context, index) {
            final appointment = controller.appointments[index];
            final lastMessage =
                controller.lastMessages[appointment.appointmentId]?.text ??
                    "No messages yet";
            final hasNewMessage =
                controller.unreadStatus[appointment.appointmentId] ?? false;

            return Dismissible(
              key: Key(appointment.appointmentId),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) async {
                // Delete chat messages from Firebase
                await controller.deleteChat(appointment.appointmentId);
                controller.appointments.removeAt(index);
              },
              child: GestureDetector(
                  onTap: () async {
                    await controller.markMessagesAsSeenOnOpen(appointment.appointmentId);
                    Get.to(() => ChatScreen(
                      appointmentId: appointment.appointmentId,
                      patientName: appointment.patientName,
                      doctorId: controller.doctorId,
                    ));
                  },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
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
                        child: Icon(Icons.person, size: 28, color: customBlue),
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
              ),
            );
          },
        );
      }),
    );
  }
}
