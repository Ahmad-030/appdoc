import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Addaboutdoctor extends StatefulWidget{
  @override
  State<Addaboutdoctor> createState() => _AddaboutdoctorState();
}

class _AddaboutdoctorState extends State<Addaboutdoctor> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController shortDescriptionController = TextEditingController();
  final TextEditingController longDescriptionController = TextEditingController();
  final TextEditingController specializationController = TextEditingController();
  final List<Map<String, dynamic>> daysAndTimes = [];
  final List<String> availableDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

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

  void _showDayTimeDialog() {
    final TextEditingController startTimeController = TextEditingController();
    final TextEditingController endTimeController = TextEditingController();
    String startAmPm = "AM";
    String endAmPm = "AM";
    String selectedDay = availableDays.first;
    List<Map<String, TextEditingController>> timeSlots = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                "Add Day and Time",
                style: TextStyle(fontFamily: 'Poppins'),
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
                      onChanged: (value) {
                        setDialogState(() {
                          selectedDay = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: startTimeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Start Time (e.g., 8:00)",
                              labelStyle: const TextStyle(fontFamily: 'Poppins', color: Colors.blue),
                              hintText: "e.g. 8:00",
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
                            ),
                            style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                          value: startAmPm,
                          items: ["AM", "PM"]
                              .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              startAmPm = value!;
                            });
                          },
                          underline: Container(),
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: endTimeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "End Time (e.g., 5:00)",
                              labelStyle: const TextStyle(fontFamily: 'Poppins', color: Colors.blue),
                              hintText: "e.g. 5:00",
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
                            ),
                            style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                          value: endAmPm,
                          items: ["AM", "PM"]
                              .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              endAmPm = value!;
                            });
                          },
                          underline: Container(),
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Add Time Slot for Appointment',
                      style: TextStyle(fontFamily: 'Poppins', color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    // Here you calculate the height dynamically based on the number of slots added
                    Container(
                      width: 400,
                      height: 80 * timeSlots.length.toDouble(), // Increase height based on the number of slots
                      child: Column(
                        children: List.generate(timeSlots.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextField(
                                    controller: timeSlots[index]['startTime'],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "Start Time",
                                      labelStyle: const TextStyle(fontFamily: 'Poppins', color: Colors.blue),
                                      hintText: "e.g. 08:00",
                                      filled: true,
                                      fillColor: Colors.blue[50],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                                    ),
                                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Center(
                                  child: Text(
                                    'To',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 3,
                                  child: TextField(
                                    controller: timeSlots[index]['endTime'],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "End Time",
                                      labelStyle: const TextStyle(fontFamily: 'Poppins', color: Colors.blue),
                                      hintText: "e.g. 17:00",
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
                                    ),
                                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
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
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedDay.isNotEmpty &&
                        startTimeController.text.isNotEmpty &&
                        endTimeController.text.isNotEmpty) {
                      setState(() {
                        daysAndTimes.add({
                          'day': selectedDay,
                          'start': "${startTimeController.text} $startAmPm",
                          'end': "${endTimeController.text} $endAmPm",
                          'timeSlots': List.from(timeSlots.map((slot) {
                            return {
                              'startTime': slot['startTime']?.text,
                              'endTime': slot['endTime']?.text,
                            };
                          })),
                        });
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    "Add Day",
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                ),

              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter Your Name Here',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: nameController,
                  decoration:  InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Enter here",
                      filled: true,
                      fillColor: Colors.grey[200]
                  ),
                  style: const TextStyle(fontFamily: 'Poppins'),
                ),
              ),

              const SizedBox(height: 10),
              const Text(
                'Enter Long Description Here',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: longDescriptionController,
                maxLines: null, // Allows unlimited lines and grows dynamically
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Enter here",
                  filled: true,
                  fillColor: Colors.grey[200],
                  alignLabelWithHint: true,
                ),
                style: const TextStyle(fontFamily: 'Poppins'),
              ),


              const SizedBox(height: 10),
              const Text(
                'Enter Specialization Here',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: specializationController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Enter here",
                    filled: true, // Enables the background color
                    fillColor: Colors.grey[200], // Sets the background color
                  ),
                  style: const TextStyle(fontFamily: 'Poppins'),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Add Your Clinic Days And  Appoinment Time',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _showDayTimeDialog,
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
              const SizedBox(height: 10),

       if (daysAndTimes.isNotEmpty)
   ListView.builder(
     shrinkWrap: true,
     physics: const NeverScrollableScrollPhysics(),
     itemCount: daysAndTimes.length,
     itemBuilder: (context, index) {
       final entry = daysAndTimes[index];
       return Card(
         margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
         elevation: 5,
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
         child: Container(
           decoration: BoxDecoration(
             gradient: const LinearGradient(
               colors: [Colors.blue, Colors.lightBlueAccent],
               begin: Alignment.topLeft,
               end: Alignment.bottomRight,
             ),
             borderRadius: BorderRadius.circular(12), // Matches the card's radius
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
                       entry['day'] ?? 'N/A',
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
                       "${entry['start'] ?? ''} - ${entry['end'] ?? ''}",
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
       );
     },
   ),



   const SizedBox(height: 10),
              GestureDetector(
                child : Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                  ),
                  child: const Center(
                    child : Text(
                      'Save Details',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Poppins'),
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