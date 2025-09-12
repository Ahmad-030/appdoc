import 'package:doctorappflutter/Auth/signinComponents/similar/custombutton.dart';
import 'package:doctorappflutter/DashboardScreen/DashboardDetailsScreen/components/doctorheader.dart';
import 'package:doctorappflutter/DocAppoinment/components/docappoinmentbody.dart';
import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllerclass/getdoctordetails.dart';

class Doctorbody extends StatefulWidget {
  @override
  State<Doctorbody> createState() => _DoctorbodyState();
}

class _DoctorbodyState extends State<Doctorbody> {
  final GetDoctorDetails controller = Get.find<GetDoctorDetails>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Doctorheader(),
            SizedBox(height: 10,),
            // About Me Section Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Me',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                      color: customBlue,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    height: 2,
                    width: 40,
                    color: customBlue.withOpacity(0.7),
                  ),
                ],
              ),
            ),

            // About Me Text
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04, vertical: screenWidth * 0.03),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(() => Text(
                  controller.doctorDetails.value?.bio ??
                      "No bio available",
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black87,
                    fontFamily: 'Poppins',
                  ),
                  softWrap: true,
                  textAlign: TextAlign.justify,
                )),
              ),
            ),

            // My Schedule Section Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Schedule',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                      color: customBlue,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    height: 2,
                    width: 40,
                    color: customBlue.withOpacity(0.7),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.01),

            // Schedule Cards
            Container(
              height: 150,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.schedule.length,
                itemBuilder: (context, index) {
                  final item = controller.schedule[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      margin: EdgeInsets.only(right: screenWidth * 0.025),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.lightBlueAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      width: 110,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item["day"]!,
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Poppins',

                            ),
                              textAlign: TextAlign.justify,
                              maxLines: 1,

                          ),

                          SizedBox(height: 4),
                          Text(
                            "${item["start"]}",
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 6),
                          Icon(Icons.access_time,
                              color: Colors.white, size: 20),
                          SizedBox(height: 6),
                          Text(
                            "${item["end"]}",
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: screenHeight * 0.01),

            // Book Appointment Button
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: CustomButton(
                title: 'Book Appointment',
                onPressed: () {
                  Get.to(Docappoinmentbody());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
