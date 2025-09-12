import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Bottomcontroller extends GetxController{
// Current selected index
  var selectedIndex = 0.obs;

  // Update the selected index
  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}