import 'package:doctorappflutter/Auth/signinComponents/similar/custombutton.dart';
import 'package:doctorappflutter/Auth/signinComponents/similar/headerdesign.dart';
import 'package:doctorappflutter/Auth/signinComponents/similar/textfeild.dart';
import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllerclass/bookappoinmentcontroller.dart';
import '../../controllerclass/getdoctordetails.dart';

class Docappoinmentbody extends StatefulWidget {
  @override
  _DocappoinmentbodyState createState() => _DocappoinmentbodyState();
}

class _DocappoinmentbodyState extends State<Docappoinmentbody> {
  final GetDoctorDetails controller = Get.find<GetDoctorDetails>();
  final BookAppointmentController appointmentController = Get.put(BookAppointmentController());

  final List<String> status = ['Online'];
  String? selectedStatus;
  String? selectedDay;
  String? selectedTime;
  DateTime? selectedDate;

  final TextEditingController _firstnamefield = TextEditingController();
  final TextEditingController _lastnamefield = TextEditingController();
  final TextEditingController _phonefield = TextEditingController();
  final TextEditingController _addressfield = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.fetchDoctorDetails();
  }

  List<DateTime> getNextThreeWeekdays(String targetDay) {
    final now = DateTime.now();
    final targetWeekday = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ].indexOf(targetDay);

    List<DateTime> upcoming = [];
    DateTime current = now;

    while (upcoming.length < 3) {
      if (current.weekday == targetWeekday + 1) {
        upcoming.add(current);
        current = current.add(Duration(days: 7));
      } else {
        current = current.add(Duration(days: 1));
      }
    }
    return upcoming;
  }

  Future<void> _pickDate() async {
    if (selectedDay == null) {
      Get.snackbar("Error", "Please select a day first.",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final options = getNextThreeWeekdays(selectedDay!);

    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((date) {
              return ListTile(
                title: Text(DateFormat('yyyy-MM-dd').format(date)),
                onTap: () {
                  setState(() {
                    selectedDate = date;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Map<String, int> parseTime(String timeStr) {
    final parts = timeStr.trim().split(' ');
    final time = parts[0];
    final amPm = parts[1];

    final hourMin = time.split(':');
    int hour = int.parse(hourMin[0]);
    int minute = int.parse(hourMin[1]);

    if (amPm == "PM" && hour != 12) hour += 12;
    if (amPm == "AM" && hour == 12) hour = 0;

    return {"hour": hour, "minute": minute};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Headerdesign(),
              const SizedBox(height: 12),
              const Text(
                'Book Appointment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: customBlue,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        title: "First name",
                        icon: Icons.person,
                        controller: _firstnamefield,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        title: "Last name",
                        icon: Icons.person,
                        controller: _lastnamefield,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                child: CustomTextField(
                  title: 'Phone number',
                  icon: Icons.phone,
                  controller: _phonefield,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                child: CustomTextField(
                  title: 'Address',
                  icon: Icons.location_on,
                  controller: _addressfield,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedStatus,
                      hint: const Text('Select Appointment Type', style: TextStyle(color: Colors.grey)),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: customBlue),
                      items: status.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins')),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedStatus = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.daysList.length,
                    itemBuilder: (context, index) {
                      final day = controller.daysList[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDay = day;
                            selectedTime = null;
                            selectedDate = null;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selectedDay == day ? customBlue : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            width: 80,
                            child: Center(
                              child: Text(
                                day.substring(0, 3),
                                style: TextStyle(
                                  color: selectedDay == day ? Colors.white : customBlue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (selectedDay != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        selectedDate == null
                            ? "Select Appointment Date"
                            : DateFormat('yyyy-MM-dd').format(selectedDate!),
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              if (selectedDay != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedTime,
                        hint: const Text('Select Appointment Time', style: TextStyle(color: Colors.grey)),
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down, color: customBlue),
                        items: controller.dayWiseTimeSlots[selectedDay]!
                            .map((value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins')),
                        ))
                            .toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedTime = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: CustomButton(
                  title: 'Send Appointment Request',
                  onPressed: () {
                    if (_firstnamefield.text.isEmpty ||
                        _phonefield.text.isEmpty ||
                        selectedDay == null ||
                        selectedTime == null ||
                        selectedStatus == null ||
                        selectedDate == null) {
                      Get.snackbar("Error", "Please fill all required fields.",
                          backgroundColor: Colors.red, colorText: Colors.white);
                    } else {
                      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
                      final timeParts = selectedTime?.split(" - ");
                      final start = parseTime(timeParts![0]);
                      final end = parseTime(timeParts[1]);

                      appointmentController.bookAppointment(
                        firstName: _firstnamefield.text,
                        lastName: _lastnamefield.text,
                        phone: _phonefield.text,
                        address: _addressfield.text,
                        appointmentDate: formattedDate,
                        startHour: start["hour"]!,
                        startMinute: start["minute"]!,
                        endHour: end["hour"]!,
                        endMinute: end["minute"]!,
                        appointmentType: selectedStatus!,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
