import 'dart:io';
import 'package:flutter/material.dart';

// =============================
// Patient Report Model
// =============================
class PatientReport {
  final String title;
  final String? imagePath;
  final bool isLocalFile;

  PatientReport({
    required this.title,
    this.imagePath,
    this.isLocalFile = false,
  });
}

// =============================
// Report Detail Screen
// =============================
class ReportDetailView extends StatelessWidget {
  final PatientReport? report;

  const ReportDetailView({Key? key, this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasReport = report != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Report Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: hasReport
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Report Information",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Display report image
            GestureDetector(
              onTap: () {
                if (report!.imagePath != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullScreenImageView(
                        imagePath: report!.imagePath!,
                        isLocalFile: report!.isLocalFile,
                      ),
                    ),
                  );
                }
              },
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: report!.imagePath != null
                    ? (report!.isLocalFile
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(report!.imagePath!),
                    fit: BoxFit.cover,
                  ),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: report!.imagePath != null
                      ? (report!.isLocalFile
                      ? Image.file(File(report!.imagePath!), fit: BoxFit.cover)
                      : Image.network(report!.imagePath!, fit: BoxFit.cover))
                      : const Center(child: Text("No image available")),
                ))
                    : const Center(
                  child: Text("No image available"),
                ),
              ),
            ),

            const SizedBox(height: 20),


            Text(
              "Title of the Report",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Display report title
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.article_outlined,
                      color: Color(0xFF4A90E2)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      report!.title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // See Full View button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (report!.imagePath != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImageView(
                          imagePath: report!.imagePath!,
                          isLocalFile: report!.isLocalFile,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "See Full View",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        )
            : const Center(
          child: Text(
            "No reports uploaded",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// =============================
// Full Screen Image View
// =============================
class FullScreenImageView extends StatelessWidget {
  final String imagePath;
  final bool isLocalFile;

  const FullScreenImageView({
    Key? key,
    required this.imagePath,
    this.isLocalFile = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: isLocalFile
            ? Image.file(File(imagePath))
            : Image.asset(imagePath),
      ),
    );
  }
}
