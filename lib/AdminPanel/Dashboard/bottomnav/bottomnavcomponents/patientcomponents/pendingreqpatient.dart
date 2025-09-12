import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../Model/appoinment.dart';
import '../../../../controller/appointmentController.dart';


class Pendingreqpatient extends StatelessWidget {
  final AppointmentController controller = Get.put(AppointmentController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Obx(() {
      // Show shimmer while loading
      if (controller.isLoading.value) {
        return ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: screenHeight * 0.17,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                ),
              ),
            );
          },
        );
      }

      // Filter only pending appointments
      final pendingAppointments = controller.appointments
          .where((appointment) => appointment.status == 'Pending')
          .toList();

      // Sort latest first
      pendingAppointments.sort((a, b) {
        final dateTimeA = DateTime.parse(a.appointmentDate).add(
          Duration(hours: a.startHour, minutes: a.startMinute),
        );
        final dateTimeB = DateTime.parse(b.appointmentDate).add(
          Duration(hours: b.startHour, minutes: b.startMinute),
        );
        return dateTimeB.compareTo(dateTimeA);
      });

      // If no appointments
      if (pendingAppointments.isEmpty) {
        return const Center(
          child: Text(
            "No pending appointments.",
            style: TextStyle(fontFamily: 'Poppins'),
          ),
        );
      }

      return ListView.builder(
        itemCount: pendingAppointments.length,
        itemBuilder: (context, index) {
          final appointment = pendingAppointments[index];
          return GestureDetector(
            onTap: () {
              _showPatientDialog(
                  context, screenWidth, screenHeight, appointment);
            },
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Container(
                height: screenHeight * 0.17,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: screenWidth * 0.02,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.05),
                      child: Container(
                        height: screenHeight * 0.08,
                        width: screenHeight * 0.08,
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(screenWidth * 0.04),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/doctorimage.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${appointment.firstName} ${appointment.lastName}",
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Text(
                            appointment.appointmentType,
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: Colors.grey[700],
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Text(
                            "Time: ${_formatTime(appointment.startHour, appointment.startMinute)} - ${_formatTime(appointment.endHour, appointment.endMinute)}",
                            style: TextStyle(
                              fontSize: screenWidth * 0.033,
                              color: Colors.grey[600],
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          appointment.appointmentDate.split("T")[0],
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  void _showPatientDialog(BuildContext context, double screenWidth,
      double screenHeight, Appointment appointment) {
    final controller = Get.find<AppointmentController>();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.03)),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Patient Details",
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/doctorimage.jpg'),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "${appointment.firstName} ${appointment.lastName}",
                  style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  appointment.appointmentType,
                  style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey[700],
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "Appointment: ${_formatTime(appointment.startHour, appointment.startMinute)} to ${_formatTime(appointment.endHour, appointment.endMinute)}",
                  style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await controller.updateAppointmentStatus(
                            appointment.id, "Accepted");
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: Text(
                        "Accept",
                        style: TextStyle(fontSize: screenWidth * 0.035),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await controller.updateAppointmentStatus(
                            appointment.id, "Cancelled");
                        Navigator.pop(context);
                      },
                      style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text(
                        "Reject",
                        style: TextStyle(fontSize: screenWidth * 0.035),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTime(int hour, int minute) {
    final time = TimeOfDay(hour: hour, minute: minute);
    return time.format(Get.context!);
  }
}
