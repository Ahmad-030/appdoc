import 'dart:async';
import 'dart:io';
import 'package:doctorappflutter/Auth/authsigninscreen.dart';
import 'package:doctorappflutter/StorageServiceClass/storageservice.dart';
import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:doctorappflutter/controllerclass/profilecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:doctorappflutter/controllerclass/getcurrentuserprofile.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController firstnamecontroller = TextEditingController();
  final TextEditingController lastnamecontroller = TextEditingController();
  final TextEditingController phonecontroller = TextEditingController();
  final TextEditingController addresscontroller = TextEditingController();
  final profileController = Get.put(Getcurrentuserprofile());
  File? _pickedImage;
  bool isImagechanged = false;

  Timer? _inactivityTimer;
  final Duration _timeout = const Duration(minutes: 5); // ⏳ 5 minutes timeout

  @override
  void initState() {
    super.initState();
    profileController.getProfileData().then((_) {
      firstnamecontroller.text = profileController.firstName.value;
      lastnamecontroller.text = profileController.lastName.value;
      phonecontroller.text = profileController.phone.value;
    });

    _resetTimer(); // start inactivity timer
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  // 🔄 Reset inactivity timer on any user interaction
  void _resetTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(_timeout, () {
      _logout(); // auto logout after timeout
    });
  }

  // 🔓 Logout logic
  void _logout() async {
    await StorageService().removeTokenAndRole();
    Get.offAll(() => Authsigninscreen());
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
      _resetTimer(); // reset inactivity on image pick
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _resetTimer, // 👆 reset timer on tap anywhere
      onPanDown: (_) => _resetTimer(), // reset on scroll/drag
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: customBlue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              _resetTimer();
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
        ),
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            _resetTimer(); // reset on scroll
            return false;
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.06),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: screenWidth * 0.20,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _pickedImage != null
                            ? FileImage(_pickedImage!)
                            : (profileController.photo.value.isNotEmpty
                            ? NetworkImage(profileController.photo.value)
                            : null) as ImageProvider?,
                        child: (_pickedImage == null &&
                            profileController.photo.value.isEmpty)
                            ? Icon(Icons.person,
                            size: screenWidth * 0.15,
                            color: Colors.grey[400])
                            : null,
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            _pickImage();
                            _resetTimer();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(screenWidth * 0.03),
                            child: Icon(
                              (_pickedImage == null &&
                                  profileController.photo.value.isEmpty)
                                  ? Icons.camera_alt
                                  : Icons.edit,
                              color: Colors.white,
                              size: screenWidth * 0.05,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Obx(() {
                  return buildTextField(
                      hintText: 'First Name',
                      icon: Icons.person,
                      screenWidth: screenWidth,
                      initialValue: profileController.firstName.value,
                      onChanged: (value) {
                        profileController.isChanged.value = true;
                        _resetTimer();
                      });
                }),
                SizedBox(height: screenHeight * 0.02),
                Obx(() {
                  return buildTextField(
                      hintText: 'Last Name',
                      icon: Icons.person,
                      screenWidth: screenWidth,
                      initialValue: profileController.lastName.value,
                      onChanged: (value) {
                        profileController.isChanged.value = true;
                        _resetTimer();
                      });
                }),
                SizedBox(height: screenHeight * 0.02),
                Obx(() {
                  return buildTextField(
                      hintText: 'Phone',
                      icon: Icons.phone,
                      screenWidth: screenWidth,
                      initialValue: profileController.phone.value,
                      onChanged: (value) {
                        profileController.isChanged.value = true;
                        _resetTimer();
                      });
                }),
                SizedBox(height: screenHeight * 0.02),
                Obx(() {
                  return buildTextField(
                      hintText: 'Address',
                      icon: Icons.location_on,
                      screenWidth: screenWidth,
                      initialValue: profileController.address.value,
                      onChanged: (value) {
                        profileController.isChanged.value = true;
                        _resetTimer();
                      });
                }),
                SizedBox(height: screenHeight * 0.04),

                // Save Profile Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: profileController.isChanged.value
                        ? () async {
                      if (_pickedImage != null) {
                        await profileController.ProfilePic(_pickedImage!);
                      } else {
                        await profileController.updateProfile(
                          firstName: firstnamecontroller.text,
                          lastName: lastnamecontroller.text,
                          phone: phonecontroller.text,
                          address: addresscontroller.text,
                        );
                      }
                      _resetTimer();
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: profileController.isChanged.value
                          ? customBlue
                          : Colors.grey,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      shadowColor: Colors.black54,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            'Save Profile',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Icon(Icons.save,
                              color: Colors.white, size: screenWidth * 0.06),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      shadowColor: Colors.black54,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Icon(Icons.logout,
                              color: Colors.white, size: screenWidth * 0.06),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String hintText,
    required IconData icon,
    required double screenWidth,
    required String initialValue,
    required Function(String) onChanged,
  }) {
    return TextField(
      controller: TextEditingController(text: initialValue),
      style: const TextStyle(fontSize: 18, fontFamily: 'Poppins'),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: customBlue),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
        prefixIcon: Icon(icon, color: customBlue, size: screenWidth * 0.06),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
    );
  }
}
