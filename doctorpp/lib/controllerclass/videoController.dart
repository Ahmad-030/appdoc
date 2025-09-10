import 'dart:async';
import 'dart:convert';
import 'package:doctorappflutter/apiconstants/apiconstantsurl.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class VideoController extends GetxController {
  var isLoading = true.obs;
  var videoList = [].obs;

  @override
  void onInit() {
    fetchVideos(); // Fetch videos initially
    Timer.periodic(Duration(seconds: 30), (timer) {
      fetchVideos(); // Auto-refresh every 30 seconds
    });
    super.onInit();
  }

  Future<void> fetchVideos() async {
    try {
      isLoading.value = true;
      final response = await http.get(
          Uri.parse("${Apiconstantsurl.baseUrl}${Apiconstantsurl.getyoutubevideo}"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var videos = data["data"]["items"];

        // Reverse the list to show latest video at the top
        videoList.assignAll(videos.reversed.toList());

        await Future.delayed(Duration(seconds: 1));
      } else {
        print("Failed to fetch videos: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching videos: $e");
    } finally {
      isLoading.value = false;
    }
  }

}
