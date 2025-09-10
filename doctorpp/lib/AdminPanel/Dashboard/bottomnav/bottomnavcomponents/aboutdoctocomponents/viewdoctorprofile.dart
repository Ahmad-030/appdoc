import 'dart:io';

import 'package:doctorappflutter/AdminPanel/common/admincustomtextfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../../controllerclass/adddoctorDetail.dart';
import '../../../../../controllerclass/getcurrentuserprofile.dart';
import '../../../../../controllerclass/getdoctordetails.dart';

class Viewdoctorprofile extends StatefulWidget{
  @override
  State<Viewdoctorprofile> createState() => _ViewdoctorprofileState();
}

class _ViewdoctorprofileState extends State<Viewdoctorprofile> {
  final Doccontroller = Get.find<GetDoctorDetails>();

  final List<String> availableDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  TextEditingController biocontroller = TextEditingController();
  TextEditingController speccontroller = TextEditingController();
  File? _pickedImage;

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }
  void _showDayTimeDialog(
      BuildContext context,
      void Function(void Function()) setState,
      Map<String, dynamic>? existingData,
      ) {
    final TextEditingController startTimeController = TextEditingController(
      text: existingData?['startTime'] ?? '',
    );
    final TextEditingController endTimeController = TextEditingController(
      text: existingData?['endTime'] ?? '',
    );
    String selectedDay = existingData?['day'] ?? availableDays.first;

    List<Map<String, TextEditingController>> timeSlots = [];

    if (existingData != null && existingData['timeSlots'] != null) {
      for (var slot in existingData['timeSlots']) {
        timeSlots.add({
          'startTime': TextEditingController(text: slot['startTime']),
          'endTime': TextEditingController(text: slot['endTime']),
        });
      }
    }

    Future<void> _pickTime(TextEditingController controller, BuildContext context, void Function(void Function()) setDialogState) async {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        final formattedTime = formatTimeOfDay(pickedTime);
        setDialogState(() {
          controller.text = formattedTime;
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                existingData != null ? "Edit Day and Time" : "Add Day and Time",
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      value: selectedDay,
                      isExpanded: true,
                      items: availableDays
                          .map((day) => DropdownMenuItem(
                        value: day,
                        child: Text(day),
                      ))
                          .toList(),
                      onChanged: existingData != null
                          ? null // Disable changing day when editing
                          : (value) {
                        setDialogState(() {
                          selectedDay = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickTime(startTimeController, context, setDialogState),
                            child: AbsorbPointer(
                              child: TextField(
                                controller: startTimeController,
                                decoration: _buildInputDecoration("Start Time"),
                                style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickTime(endTimeController, context, setDialogState),
                            child: AbsorbPointer(
                              child: TextField(
                                controller: endTimeController,
                                decoration: _buildInputDecoration("End Time"),
                                style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Add Time Slot for Appointment',
                      style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: List.generate(timeSlots.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _pickTime(timeSlots[index]['startTime']!, context, setDialogState),
                                  child: AbsorbPointer(
                                    child: TextField(
                                      controller: timeSlots[index]['startTime'],
                                      decoration: _buildInputDecoration("Start"),
                                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text('To', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _pickTime(timeSlots[index]['endTime']!, context, setDialogState),
                                  child: AbsorbPointer(
                                    child: TextField(
                                      controller: timeSlots[index]['endTime'],
                                      decoration: _buildInputDecoration("End"),
                                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          setDialogState(() {
                            timeSlots.add({
                              'startTime': TextEditingController(),
                              'endTime': TextEditingController(),
                            });
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Add Time Slot',
                          style: TextStyle(fontFamily: 'Poppins', color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel", style: TextStyle(fontFamily: 'Poppins')),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedDay.isNotEmpty &&
                        startTimeController.text.isNotEmpty &&
                        endTimeController.text.isNotEmpty) {
                      Doccontroller.addOrUpdateDaySchedule(
                        day: selectedDay,
                        startTime: startTimeController.text,
                        endTime: endTimeController.text,
                        timeSlots: List<Map<String, String>>.from(timeSlots.map((slot) {
                          return {
                            'startTime': slot['startTime']?.text ?? '',
                            'endTime': slot['endTime']?.text ?? '',
                          };
                        })),
                      );

                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    existingData != null ? "Update Day" : "Add Day",
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontFamily: 'Poppins', color: Colors.blue),
      filled: true,
      fillColor: Colors.blue[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
    );
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat('hh:mm a'); // Change to 'HH:mm' for 24-hour format
    return format.format(dt);
  }

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Doccontroller.fetchDoctorDetails();
    biocontroller.text = Doccontroller.biocontroller.text;
    speccontroller.text = Doccontroller.speccontroller.text;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Doccontroller.clearTempDaysAndTimes();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _pickedImage != null
                          ? FileImage(_pickedImage!)
                          : null,
                      child: _pickedImage == null
                          ? Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.grey[400],
                      )
                          : null,
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'First Name',
                  style: const TextStyle(
                    fontFamily: 'poppins',
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

              const SizedBox(height: 10),
               Admincustomtextfield(
                edcontroller: biocontroller,
                hintText: 'Long Description Here',
                 minlines: 2,
              ),
              const SizedBox(height: 10),
              Admincustomtextfield(
                edcontroller: speccontroller,
                hintText: 'Specialization Here',
              ),
              
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align( alignment: Alignment.topLeft,
                    child: Text('Days And Time Slot For Appoinment',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'poppins',color: Colors.black,fontSize: 16),)),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: (){
                    _showDayTimeDialog(context, setState,null);
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add_circle_outline, color: Colors.blue),
                        SizedBox(width: 10),
                        Text(
                          "Add Day",
                          style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(() {
                final mergedList = <Map<String, dynamic>>[];

                final tempMap = {
                  for (var item in Doccontroller.tempDaysAndTimes) item['day']: item
                };

                // Merge backend schedule with temp overrides
                for (var item in Doccontroller.schedule) {
                  final day = item['day'];
                  if (day == null) continue;

                  if (tempMap.containsKey(day)) {
                    mergedList.add(tempMap[day]!); // Use edited temp entry
                  } else {
                    final timeSlots = Doccontroller.dayWiseTimeSlots[day] ?? [];
                    mergedList.add({
                      'day': day,
                      'startTime': item['start'],
                      'endTime': item['end'],
                      'timeSlots': timeSlots.map((slot) {
                        final parts = slot.split(" - ");
                        return {
                          'startTime': parts[0],
                          'endTime': parts[1],
                        };
                      }).toList(),
                    });
                  }
                }

                // Add any new days from temp list that aren't in backend
                for (var item in Doccontroller.tempDaysAndTimes) {
                  if (!Doccontroller.schedule.any((s) => s['day'] == item['day'])) {
                    mergedList.add(item);
                  }
                }

                if (mergedList.isEmpty) {
                  return const SizedBox.shrink();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: mergedList.length,
                  itemBuilder: (context, index) {
                    final entry = mergedList[index];

                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showDayTimeDialog(context, setState, entry);
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 9),
                            elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.blue, Colors.lightBlueAccent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header Row with Day and Icon
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today, color: Colors.white, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          (entry['day'] ?? 'N/A') as String,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    // Start and End Times
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time, color: Colors.white70, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          "${entry['startTime'] ?? ''} - ${entry['endTime'] ?? ''}",
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    // Divider
                                    Divider(color: Colors.white.withOpacity(0.4)),

                                    // Time Slots
                                    if ((entry['timeSlots'] as List?)?.isNotEmpty ?? false)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Time Slots:",
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          ...((entry['timeSlots'] as List).map((slot) {
                                            return Row(
                                              children: [
                                                const Icon(Icons.schedule, color: Colors.white70, size: 16),
                                                const SizedBox(width: 8),
                                                Text(
                                                  "${slot['startTime'] ?? ''} - ${slot['endTime'] ?? ''}",
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList()),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),


                      ],
                    );
                  },
                );

              })
              ,
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  final existing = Doccontroller.daysAndTimes;
                final temp = Doccontroller.tempDaysAndTimes;

                // Filter out duplicates based on day
                final filteredExisting = existing.where((existingItem) {
                  return !temp.any((tempItem) => tempItem['day'] == existingItem['day']);
                }).toList();

                // Combine both lists
                final combined = [...filteredExisting, ...temp];

                // Normalize time formats and structures
                final normalizedCombined = normalizeDaysAndTimes(combined);

                // Convert to final format
                final converted = convertToWorkingDays(normalizedCombined)['workingDays'];

                print('converted list: $converted');

                // Call API or controller to save
                Doccontroller.addDetails(
                  clinicAddress: '123 Main St, New York, NY',
                  clinicPhone: '+1 234-567-8901',
                  specialization: speccontroller.text.trim(),
                  bio: biocontroller.text.trim(),
                  workingDays: converted,
                );


                },

                child : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                    child: const Center(
                      child : Text(
                        'Update Details',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
Map<String, dynamic> convertToWorkingDays(List<Map<String, dynamic>> daysAndTimes) {
  List<Map<String, dynamic>> workingDays = [];

  for (var entry in daysAndTimes) {
    try {
      String cleanedStart = cleanTime(entry['startTime'] ?? '');
      String cleanedEnd = cleanTime(entry['endTime'] ?? '');

      Map<String, dynamic> start = splitTime(cleanedStart);
      Map<String, dynamic> end = splitTime(cleanedEnd);

      List<Map<String, dynamic>> appointSlots = [];

      if (entry['timeSlots'] != null) {
        for (var slot in entry['timeSlots']) {
          try {
            String slotStartClean = cleanTime(slot['startTime'] ?? '');
            String slotEndClean = cleanTime(slot['endTime'] ?? '');

            appointSlots.add({
              'startTime': splitTime(slotStartClean),
              'endTime': splitTime(slotEndClean),
            });
          } catch (e) {
            print('Error parsing timeSlot: $e');
          }
        }
      }

      workingDays.add({
        'day': entry['day'],
        'startTime': start,
        'endTime': end,
        'appointSlots': appointSlots,
      });
    } catch (e) {
      print('Error parsing entry: $e');
    }
  }

  return {'workingDays': workingDays};
}


Map<String, dynamic> splitTime(String timeStr) {
  final parts = timeStr.trim().split(' ');
  final time = parts[0].split(':');

  if (time.length != 2 || parts.length != 2) {
    throw FormatException("Invalid time format: $timeStr");
  }

  int hour = int.parse(time[0]);
  int minute = int.parse(time[1]);
  String period = parts[1].toUpperCase();

  return {'hour': hour, 'minute': minute, 'period': period};
}

String cleanTime(String time) {
  return time.replaceAll(RegExp(r'[^\x00-\x7F]'), '').trim();
}
List<Map<String, dynamic>> normalizeDaysAndTimes(List<Map<String, dynamic>> daysAndTimes) {
  return daysAndTimes.map((entry) {
    // Handle cases where keys are 'start'/'end' instead of 'startTime'/'endTime'
    final startTime = entry['startTime'] ?? entry['start'] ?? '';
    final endTime = entry['endTime'] ?? entry['end'] ?? '';
    final day = entry['day'];

    // Normalize timeSlots
    List<Map<String, dynamic>> timeSlots = [];
    if (entry['timeSlots'] != null && entry['timeSlots'] is List) {
      for (var slot in entry['timeSlots']) {
        if (slot is String && slot.contains('-')) {
          final parts = slot.split('-');
          timeSlots.add({
            'startTime': parts[0].trim(),
            'endTime': parts[1].trim(),
          });
        } else if (slot is Map) {
          timeSlots.add({
            'startTime': slot['startTime'] ?? '',
            'endTime': slot['endTime'] ?? '',
          });
        }
      }
    }

    return {
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
      'timeSlots': timeSlots,
    };
  }).toList();
}





