
import 'package:doctorappflutter/AdminPanel/Dashboard/bottomnav/bottomnavcomponents/patientcomponents/acceptreqpatient.dart';
import 'package:doctorappflutter/AdminPanel/Dashboard/bottomnav/bottomnavcomponents/patientcomponents/pendingreqpatient.dart';
import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:doctorappflutter/controllerclass/getdoctordetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../bottomnavcomponents/patientcomponents/userlist.dart';
 // Assuming customBlue is defined here

class Patient extends StatefulWidget {
  @override
  State<Patient> createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  final GetDoctorDetails controller = Get.put(GetDoctorDetails());
  @override
  void initState() {
    controller.fetchDoctorDetails();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: customBlue,
            title: const Text(
              "Request Details",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'Poppins',
                color: Colors.white
              ),
            ),
              automaticallyImplyLeading: false
          ),
          body: Column(
            children: [
              // Padding around the Container
              Padding(
                padding: const EdgeInsets.all(7.0), // Add padding to all sides
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: customBlue, // TabBar background color
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // Changes position of shadow
                      ),
                    ],
                  ),
                  child: const TabBar(
                    indicatorColor: Colors.white, // Color of the selected tab underline
                    labelColor: Colors.black, // Color of the selected tab text
                    unselectedLabelColor: Colors.grey, // Color of the unselected tab text
                    tabs: [
                      Tab(
                        child: Text(
                          "Received",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Booked",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "User",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Expanded TabBarView to take up remaining space
              Expanded(
                child: TabBarView(
                  children: [
                    // Active Patient List
                    Pendingreqpatient(),
                    Acceptreqpatient(),
                    UserList()
                    // Pending Patient Center Text


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
