import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Addmedicinetopatient extends StatefulWidget {
  final String appointmentId; // Unique appointment ID

  const Addmedicinetopatient({Key? key, required this.appointmentId}) : super(key: key);

  @override
  State<Addmedicinetopatient> createState() => _AddmedicinetopatientState();
}

class _AddmedicinetopatientState extends State<Addmedicinetopatient> {
  final List<Map<String, TextEditingController>> _controllersList = [];

  @override
  void initState() {
    super.initState();
    _addTextField(); // Start with one empty text field
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

  /// Save all new medicines to Firebase under the appointment ID
  Future<void> _saveMedicines() async {
    final now = DateTime.now();
    final batch = FirebaseFirestore.instance.batch();

    for (var controllerMap in _controllersList) {
      final medicineName = controllerMap['medicine']?.text.trim();
      final description = controllerMap['description']?.text.trim();

      if (medicineName != null && medicineName.isNotEmpty) {
        final docRef = FirebaseFirestore.instance
            .collection('appointments')
            .doc(widget.appointmentId)
            .collection('medicines')
            .doc(); // Auto-generated ID

        batch.set(docRef, {
          'medicine': medicineName,
          'description': description ?? '',
          'date': now.toIso8601String(),
        });
      }
    }

    try {
      await batch.commit();

      // Clear all text fields after saving
      for (var controllers in _controllersList) {
        controllers['medicine']?.clear();
        controllers['description']?.clear();
      }

      // Add a fresh empty text field
      if (_controllersList.isEmpty) _addTextField();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medicines saved successfully!')),
      );
    } catch (e) {
      print('Error saving medicines: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save medicines.')),
      );
    }
  }

  /// Stream for real-time updates from Firestore
  Stream<List<Map<String, dynamic>>> _assignedMedicinesStream() {
    return FirebaseFirestore.instance
        .collection('appointments')
        .doc(widget.appointmentId)
        .collection('medicines')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      // Convert docs to list
      final medicines = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      // Remove duplicates (by medicine name) and keep the last two
      final uniqueMap = <String, Map<String, dynamic>>{};
      for (var med in medicines) {
        uniqueMap[med['medicine']] = med;
      }

      // Get last two
      final lastTwo = uniqueMap.values.toList();
      lastTwo.sort((a, b) => b['date'].compareTo(a['date'])); // Sort descending
      return lastTwo.take(2).toList();
    });
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
            'Recently Assigned Medicines',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _assignedMedicinesStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }

              final medicines = snapshot.data!;
              if (medicines.isEmpty) {
                return Container(
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
                );
              }

              return Column(
                children: medicines.map((med) {
                  final date = DateTime.tryParse(med['date'] ?? '');
                  final formattedDate =
                  date != null ? '${date.day}-${date.month}-${date.year}' : '';
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
                            'Date: $formattedDate',
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
              );
            },
          ),

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
            onPressed: _saveMedicines,
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
          ),
        ],
      ),
    );
  }
}
