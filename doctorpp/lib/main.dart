import 'package:doctorappflutter/AdminPanel/Dashboard/bottomnav/adminnavbottom.dart';
import 'package:doctorappflutter/Auth/authsignupscreen.dart';
import 'package:doctorappflutter/Auth/resetpasswordscreen.dart';
import 'package:doctorappflutter/DashboardScreen/userbottomnav.dart';
import 'package:doctorappflutter/StorageServiceClass/storageservice.dart';
import 'package:doctorappflutter/ahmadswork/Pending_approval.dart';
import 'package:doctorappflutter/splashscreen/frontscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// Adjust the import based on your folder structure
import 'Auth/signinComponents/signinbody.dart';
import 'DashboardScreen/DashboardDetailsScreen/reportsdetails.dart';

Future<void> main() async {
  await GetStorage.init();
  String? token = StorageService().readToken();
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;

  // Constructor
  MyApp({required this.token});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Use the token for navigation logic here
      // token != null ? Userbottomnav() : Authsignupscreen()
      home: Frontscreen()
    );
  }
}
