import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewExerciseVideo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Adjust crossAxisCount based on screen width
                    int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;

                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: constraints.maxWidth > 600 ? 0.8 : 0.7,
                      children: List.generate(15, (index) {
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white, // Container color
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5), // Shadow color with opacity
                                  spreadRadius: 1, // Spread radius
                                  blurRadius: 2, // Blur radius
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8), // Make the image corners round
                                    child: Image.asset(
                                      'assets/images/exceriseimage.jpg',
                                      fit: BoxFit.cover, // Ensure the image covers the area
                                      width: double.infinity,
                                      height: constraints.maxWidth > 600 ? 200 : 160, // Responsive height
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'Exercise name',
                                    style: TextStyle(
                                      color: Colors.blue, // Replace with your custom color
                                      fontWeight: FontWeight.bold,
                                      fontSize: constraints.maxWidth > 600 ? 18 : 15, // Responsive font size
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                                Container(
                                  width: constraints.maxWidth > 600 ? 200 : 150, // Responsive button width
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Navigate to ExerciseVideoPlay
                                      // Get.to(ExerciseVideoPlay());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue, // Replace with your custom color
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Play',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
