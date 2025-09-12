import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../Model/appoinment.dart';
import '../../../../../controllerclass/appointmentAllUserController.dart';

class UserList extends StatefulWidget {
  UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final controller = Get.put(Appointmentallusercontroller());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShimmerList(screenWidth, screenHeight);
      }

      if (controller.appointments.isEmpty) {
        return const Center(child: Text("No appointments found"));
      }

      // ✅ Sort latest first
      final appointments = [...controller.appointments]..sort((a, b) {
        final dateTimeA = DateTime.parse(a.appointmentDate).add(
          Duration(hours: a.startHour, minutes: a.startMinute),
        );
        final dateTimeB = DateTime.parse(b.appointmentDate).add(
          Duration(hours: b.startHour, minutes: b.startMinute),
        );
        return dateTimeB.compareTo(dateTimeA);
      });

      return ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];

          return GestureDetector(
            onTap: () => _showPatientDialog(
                context, screenWidth, screenHeight, appointment),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Container(
                height: screenHeight * 0.18,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
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
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Text(
                            appointment.phone,
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: Colors.grey[700],
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Text(
                            appointment.status,
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: appointment.status == "Accepted"
                                  ? Colors.green
                                  : Colors.orange,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
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

  /// Shimmer effect while loading
  Widget _buildShimmerList(double screenWidth, double screenHeight) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: screenHeight * 0.18,
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

  /// Patient details dialog
  void _showPatientDialog(BuildContext context, double screenWidth,
      double screenHeight, Appointment appointment) {
    final startTime =
        "${appointment.startHour.toString().padLeft(2, '0')}:${appointment.startMinute.toString().padLeft(2, '0')}";
    final endTime =
        "${appointment.endHour.toString().padLeft(2, '0')}:${appointment.endMinute.toString().padLeft(2, '0')}";
    final formattedDate =
    DateFormat('yyyy-MM-dd').format(DateTime.parse(appointment.appointmentDate));

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
          ),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: SingleChildScrollView(
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
                  CircleAvatar(
                    radius: screenWidth * 0.12,
                    backgroundImage:
                    const AssetImage('assets/images/doctorimage.jpg'),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _dialogText("Name",
                      "${appointment.firstName} ${appointment.lastName}", screenWidth),
                  _dialogText("Phone", appointment.phone, screenWidth),
                  _dialogText("Address", appointment.address, screenWidth),
                  _dialogText("Date", formattedDate, screenWidth),
                  _dialogText("Time", "$startTime - $endTime", screenWidth),
                  _dialogText("Type", appointment.appointmentType, screenWidth),
                  _dialogText("Status", appointment.status, screenWidth,
                      color: appointment.status == "Accepted"
                          ? Colors.green
                          : Colors.orange),
                  const Divider(thickness: 1),
                  _dialogText("Doctor",
                      "${appointment.doctorFirstName} ${appointment.doctorLastName}",
                      screenWidth),
                  _dialogText("Email", appointment.doctorEmail, screenWidth),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _dialogText(String label, String value, double screenWidth,
      {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: screenWidth * 0.037,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: screenWidth * 0.037,
                color: color ?? Colors.black87,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
