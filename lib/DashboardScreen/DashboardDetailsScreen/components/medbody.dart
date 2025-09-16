import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:flutter/material.dart';

class Medbody extends StatefulWidget {
  final String appointmentId; // Pass the patient's appointment ID

  const Medbody({Key? key, required this.appointmentId}) : super(key: key);

  @override
  _MedbodyState createState() => _MedbodyState();
}

class _MedbodyState extends State<Medbody> {
  List<Map<String, dynamic>> medlist = [];
  bool isLoading = true; // For initial loading indicator

  @override
  void initState() {
    super.initState();
    _fetchMedicines();
  }

  /// Fetch medicines from Firebase for this appointment
  Future<void> _fetchMedicines() async {
    setState(() {
      isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(widget.appointmentId)
          .collection('medicines')
          .orderBy('date', descending: true) // most recent first
          .limit(2) // only last 2 medicines
          .get();

      final medicines = snapshot.docs.map((doc) => doc.data()).toList();

      setState(() {
        medlist = medicines.cast<Map<String, dynamic>>();
      });
    } catch (e) {
      print('Error fetching medicines: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Pull-to-refresh handler
  Future<void> _refreshMedicines() async {
    await _fetchMedicines();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (medlist.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refreshMedicines,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 50),
            Center(
              child: Text(
                'No medicines assigned yet.',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshMedicines,
      child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: medlist.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final medicine = medlist[index];
          final date = DateTime.tryParse(medicine['date'] ?? '');
          final formattedDate =
          date != null ? '${date.year}-${date.month}-${date.day}' : '';

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine['medicine'] ?? '',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          medicine['description'] ?? '',
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      formattedDate,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: customBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
