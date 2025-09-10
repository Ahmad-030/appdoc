import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:flutter/material.dart';

class Viewpatientreport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: 6,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 180, // Increased height to accommodate the button
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Doctor Image
                            Container(
                              height: 65,
                              width: 65,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/doctorimage.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Doctor Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Ayesha Salman",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    "Online",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: customBlue,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Appointment: 10:00 AM To 11:00 AM ',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                        fontFamily: 'Poppins',
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: '(Monday)',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox( height: 10,),
                                  // View Report Button
                                  ElevatedButton(
                                    onPressed: () {
                                      // Add your onPressed functionality here
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: customBlue,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 20.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: const Text(
                                      'View Report',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
