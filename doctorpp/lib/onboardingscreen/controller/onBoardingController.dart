
import 'dart:async';
import 'dart:ui' as ui;

import 'package:doctorappflutter/Auth/authsignupscreen.dart';
import 'package:doctorappflutter/onboardingscreen/model/onBoardingModel.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();
  // final homeController = Get.put(HomeController());

  var currentPage = 0.obs;
  var screen = <OnBoardingModel>[].obs;

  Future<void> loadImages() async {
    final List<OnBoardingModel> tempScreen = [
      OnBoardingModel(image: await loadUiImage("assets/images/onboardingone.jpg"), title: "Book Appointments Easily.\nConsult Expert Physiotherapists." ),
      OnBoardingModel(image: await loadUiImage("assets/images/onboardingtwo.jpg"), title: "Follow Guided Exercises.\nImprove Recovery with Video Tutorials." ),
      OnBoardingModel(image: await loadUiImage("assets/images/onboardingthreee.jpg"), title: "Track Your Progress.\nPersonalized Plans for Faster Healing." ),
    ];
    screen.addAll(tempScreen);
  }

  Future<ui.Image> loadUiImage(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(data.buffer.asUint8List(), (ui.Image img) {
      completer.complete(img);
    },);
    return completer.future;
  }

  void updatePage(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if(currentPage.value < screen.length - 1) {
      currentPage.value ++;
    } else {
      Get.to(() => Authsignupscreen());
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadImages();
  }
}
