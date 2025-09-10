import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controllerclass/getdoctordetails.dart';

class Doctor extends StatelessWidget {
  final GetDoctorDetails controller = Get.find<GetDoctorDetails>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final avatarRadius = screenWidth * 0.08; // ~8% of screen width
    final maxBioLines = screenHeight < 650 ? 4 : 7;

    return Obx(() {
      if (controller.isLoading.value) {
        // Shimmer loading effect
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: avatarRadius, backgroundColor: Colors.white),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: screenWidth * 0.4, height: 15, color: Colors.white),
                        const SizedBox(height: 5),
                        Container(width: screenWidth * 0.25, height: 12, color: Colors.white),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(height: 150, color: Colors.white),
              ],
            ),
          ),
        );
      }

      final doctor = controller.doctorDetails.value;
      if (doctor == null) {
        return const Center(child: Text("No doctor data found."));
      }

      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundImage: const AssetImage('assets/images/doctorimage.jpg'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.specialization ?? 'Dr. Name',
                        style: const TextStyle(
                          fontSize: 22,
                          color: customBlue,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        doctor.specialization ?? 'Specialization',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              doctor.bio ?? 'Doctor Bio',
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
              textAlign: TextAlign.justify,
              overflow: TextOverflow.ellipsis,
              maxLines: 6, // Let it fill naturally, clip by height
            ),

          ],
        ),
      );
    });
  }
}
