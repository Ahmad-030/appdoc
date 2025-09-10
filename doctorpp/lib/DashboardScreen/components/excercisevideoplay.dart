import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:get/get.dart';

class ExerciseVideoPlay extends StatefulWidget {
  final String videoId;
  final List videoList;

  const ExerciseVideoPlay({Key? key, required this.videoId, required this.videoList}) : super(key: key);

  @override
  _ExerciseVideoPlayState createState() => _ExerciseVideoPlayState();
}

class _ExerciseVideoPlayState extends State<ExerciseVideoPlay> {
  late YoutubePlayerController _controller;
  late String currentVideoId;

  @override
  void initState() {
    super.initState();
    currentVideoId = widget.videoId;
    _controller = YoutubePlayerController.fromVideoId(
      videoId: currentVideoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
          enableJavaScript: true, // Ensures smooth player functionality
          mute: false
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List suggestedVideos = widget.videoList.where((video) {
      return video["snippet"]["resourceId"]["videoId"] != currentVideoId;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Exercise Video",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)], // Blue Gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Video Player with Soft Shadow
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
              ],
            ),
            margin: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: YoutubePlayer(controller: _controller),
              ),
            ),
          ),

          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(top: 3.0, left: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Suggested Exercise Videos',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black

                ),
              ),
            ),
          ),

          // Suggestions List with Better UI
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(10.0),
              itemCount: suggestedVideos.length,
              itemBuilder: (context, index) {
                var video = suggestedVideos[index];
                var thumbnailUrl = video["snippet"]["thumbnails"]["high"]["url"];
                var title = video["snippet"]["title"];
                var videoId = video["snippet"]["resourceId"]["videoId"];
                var channelTitle = video["snippet"]["videoOwnerChannelTitle"];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentVideoId = videoId;
                      _controller.loadVideoById(videoId: videoId);
                    });
                  },
                  child: Card(
                    elevation: 6,
                    shadowColor: Colors.grey.withOpacity(0.3),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        // Video Thumbnail with Rounded Borders
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                          child: Image.network(
                            thumbnailUrl,
                            width: 130,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Video Details
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.black87,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.video_collection, color: Colors.blueAccent, size: 16),
                                    const SizedBox(width: 5),
                                    Text(
                                      channelTitle,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Play Icon
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(Icons.play_circle_fill, color: Colors.redAccent.shade400, size: 30),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
