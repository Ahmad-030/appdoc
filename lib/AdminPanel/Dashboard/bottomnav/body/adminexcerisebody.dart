
import 'package:doctorappflutter/AdminPanel/Dashboard/bottomnav/bottomnavcomponents/excerisecomponent/uploadExercise.dart';
import 'package:doctorappflutter/AdminPanel/Dashboard/bottomnav/bottomnavcomponents/excerisecomponent/viewexcerisevideo.dart';
import 'package:doctorappflutter/DashboardScreen/components/excercisevideoplay.dart';
import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:doctorappflutter/controllerclass/videoController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Adminexcerisebody extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return ExceriseState();
  }
}

class ExceriseState extends State<Adminexcerisebody> {
  final VideoController videoController = Get.put(VideoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (videoController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (videoController.videoList.isEmpty) {
          return const Center(child: Text("No videos found"));
        }
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(8.0),
          itemCount: videoController.videoList.length,
          itemBuilder: (context, index) {
            var video = videoController.videoList[index];
            var thumbnailUrl = video["snippet"]["thumbnails"]["high"]["url"];
            var title = video["snippet"]["title"];
            var videoId = video["snippet"]["resourceId"]["videoId"];
            var channelTitle = video["snippet"]["videoOwnerChannelTitle"];

            return GestureDetector(
              onTap: () {
                Get.to(() => ExerciseVideoPlay(videoId: videoId, videoList: videoController.videoList));              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// **Video Thumbnail (16:9 Aspect Ratio)**
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: AspectRatio(
                          aspectRatio: 16 / 9, // Landscape format
                          child: Image.network(
                            thumbnailUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      /// **Video Details**
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// **Channel Icon Placeholder**
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20), // Circular icon
                              child: Image.asset(
                                "assets/images/splashscreen.png",
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),

                            /// **Title & Channel Name**
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    channelTitle,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
