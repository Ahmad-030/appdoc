import 'package:doctorappflutter/chat/doctor%20side/Patient%20list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

import '../../../../../Model/appoinment.dart';
import '../../../../../constant/constantfile.dart';
import '../../../../controller/acceptedAppointmentController.dart';
import '../medicinecomponents/addmedicinetopatient.dart';

class Acceptreqpatient extends StatelessWidget {
  final AcceptedAppointmentController controller =
  Get.put(AcceptedAppointmentController());

  Acceptreqpatient({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Appointment list
        Obx(() {
          final appointments = controller.appointments;

          // Loading shimmer
          if (controller.isLoading.value) {
            return ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 155,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            );
          }

          // No appointments
          if (appointments.isEmpty) {
            return const Center(
              child: Text(
                'No accepted appointments found.',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            );
          }

          // Appointment list
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (BuildContext context, int index) {
              final appointment = appointments[index];
              final date = DateTime.parse(appointment.appointmentDate);
              final dayName = DateFormat('EEEE').format(date);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => _showPatientDetailsDialog(context, appointment),
                  child: Container(
                    height: 155,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/doctorimage.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${appointment.firstName} ${appointment.lastName}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  appointment.appointmentType,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: customBlue,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 5),
                                RichText(
                                  text: TextSpan(
                                    text:
                                    'Appointment: ${_formatTime(appointment.startHour, appointment.startMinute)} To ${_formatTime(appointment.endHour, appointment.endMinute)} ',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                      fontFamily: 'Poppins',
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                        "($dayName, ${appointment.appointmentDate.split("T")[0]})",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
        }),

        // Custom chat button
        Positioned(
          right: 16,
          bottom: 16,
          child: GestureDetector(
            onTap: () {
              Get.to(() => DoctorAppointmentsScreen());
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: customBlue,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.chat,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(int hour, int minute) {
    final time = TimeOfDay(hour: hour, minute: minute);
    return time.format(Get.context!);
  }

  void _showPatientDetailsDialog(BuildContext context, Appointment appointment) {
    final date = DateTime.parse(appointment.appointmentDate);
    final dayName = DateFormat('EEEE').format(date);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Patient Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/doctorimage.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${appointment.firstName} ${appointment.lastName}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        appointment.appointmentType,
                        style: const TextStyle(
                          fontSize: 11,
                          color: customBlue,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Appointment: ${_formatTime(appointment.startHour, appointment.startMinute)} To ${_formatTime(appointment.endHour, appointment.endMinute)} ($dayName)",
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Date: ${appointment.appointmentDate.split("T")[0]}",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Addmedicinetopatient(
                      appointmentId:
                          appointment.id, // <-- Pass the appointment ID here
                    ),
                  ),
                );
              },
              child: const Text(
                "Assign Medicine",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "View Report",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
