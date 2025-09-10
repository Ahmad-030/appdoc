import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Addmedicinetopatient extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MedState();
  }
}

class MedState extends State<Addmedicinetopatient> {
  final List<Map<String, String>> assignedMedicines = [
    {
      'medicine': 'Paracetamol',
      'description': 'Take after meals twice a day.',
      'date': '2025-06-26',
    },
    {
      'medicine': 'Cough Syrup',
      'description': '10ml at night before sleep.',
      'date': '2025-06-27',
    },
  ];

  final List<Map<String, TextEditingController>> _controllersList = [];

  @override
  void initState() {
    super.initState();
    _addTextField();
  }

  void _addTextField() {
    setState(() {
      _controllersList.add({
        'medicine': TextEditingController(),
        'description': TextEditingController(),
      });
    });
  }

  void _removeTextField(int index) {
    setState(() {
      _controllersList[index]['medicine']?.dispose();
      _controllersList[index]['description']?.dispose();
      _controllersList.removeAt(index);
    });
  }

  @override
  void dispose() {
    for (var controllers in _controllersList) {
      controllers['medicine']?.dispose();
      controllers['description']?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customBlue,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Assign Medicines',
          style: GoogleFonts.poppins(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// Previously Assigned Section
          Text(
            'Previously Assigned Medicines',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          if (assignedMedicines.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Center(
                child: Text(
                  'No medicines assigned yet.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            )
          else
            ...assignedMedicines.map((med) {
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        med['medicine'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        med['description'] ?? '',
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Date: ${med['date']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

          const SizedBox(height: 25),
          Divider(color: Colors.white54),
          const SizedBox(height: 20),

          /// New Medicine Section
          Text(
            'Add New Medicines',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _controllersList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: _controllersList[index]['medicine'],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.medical_information, color: Colors.blue),
                                hintText: 'Medicine',
                              ),
                            ),
                            TextField(
                              controller: _controllersList[index]['description'],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.description, color: Colors.blue),
                                hintText: 'Description',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        index == _controllersList.length - 1 ? Icons.add : Icons.delete,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        index == _controllersList.length - 1
                            ? _addTextField()
                            : _removeTextField(index);
                      },
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              // Save medicines to backend here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'Save Medicines',
              style: GoogleFonts.poppins(
                color: customBlue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
