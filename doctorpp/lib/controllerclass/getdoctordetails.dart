import 'package:doctorappflutter/Model/doctor/doctorDetailsResponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../apiconstants/apiconstantsurl.dart';
class GetDoctorDetails extends GetxController {
  var isLoading = false.obs;
  var doctorDetails = Rxn<DoctorDetails>();
  final biocontroller = TextEditingController();
  final speccontroller = TextEditingController();
  var schedule = <Map<String, String>>[].obs;

  final RxList<String> daysList = <String>[].obs;
  final RxMap<String, List<String>> dayWiseTimeSlots = <String, List<String>>{}.obs;

  // temp list for saving
  var tempDaysAndTimes = <Map<String, dynamic>>[].obs;

  void addOrUpdateDaySchedule({
    required String day,
    required String startTime,
    required String endTime,
    required List<Map<String, String>> timeSlots,
  }) {
    final existingIndex = tempDaysAndTimes.indexWhere((item) => item['day'] == day);

    final newEntry = {
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
      'timeSlots': timeSlots,
    };

    if (existingIndex != -1) {
      tempDaysAndTimes[existingIndex] = newEntry;
    } else {
      tempDaysAndTimes.add(newEntry);
    }

    update();
  }



  void clearTempDaysAndTimes() {
    tempDaysAndTimes.clear();
  }

  // get the doctor details
  List<Map<String, dynamic>> get daysAndTimes {
    return schedule.map((dayMap) {
      final dayName = dayMap['day'];
      return {
        'day': dayName,
        'start': dayMap['start'],
        'end': dayMap['end'],
        'timeSlots': dayWiseTimeSlots[dayName] ?? [],
      };
    }).toList();
  }
  Future<void> fetchDoctorDetails() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse("${Apiconstantsurl.baseUrl}${Apiconstantsurl.getdoctordetails}"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final doctorResponse = DoctorDetailsResponse.fromJson(data);
        doctorDetails.value = doctorResponse.doctorDetails;
        biocontroller.text = doctorResponse.doctorDetails.bio ?? '';
        speccontroller.text = doctorResponse.doctorDetails.specialization ?? '';
        schedule.clear();
        daysList.clear();
        dayWiseTimeSlots.clear();

        for (var day in doctorResponse.doctorDetails.workingDays) {
          final dayName = day.day;
          daysList.add(dayName);
          schedule.add({
            "day": dayName,
            "start": day.startTime.formattedTime,
            "end": day.endTime.formattedTime,
          });

          List<String> timeSlots = [];
          for (var slot in day.appointSlots) {
            final formattedSlot = "${slot.startTime.formattedTime} - ${slot.endTime.formattedTime}";
            timeSlots.add(formattedSlot);
          }

          dayWiseTimeSlots[dayName] = timeSlots;
        }
      }
    }catch (e){

    } finally {
      isLoading.value = false;
    }
  }

  // add the doctor details
  final _box = GetStorage();
  var isloading = false.obs;

  Future<void> addDetails({
    required String clinicAddress,
    required String clinicPhone,
    required String specialization,
    required String bio,
    required List<Map<String, dynamic>> workingDays,
  }) async {
    try {
      isloading.value = true;
      String? token = _box.read("auth_token");

      final body = {
        "clinicAddress": clinicAddress,
        "clinicPhone": clinicPhone,
        "specialization": specialization,
        "bio": bio,
        "workingDays": workingDays,
      };

      final response = await http.put(
        Uri.parse("${Apiconstantsurl.baseUrl}${Apiconstantsurl.getdoctordetails}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      isloading.value = false;

      if (response.statusCode == 200) {
        print("Doctor details updated successfully!");
        clearTempDaysAndTimes();
        await fetchDoctorDetails();
        // Show success toast/snackbar
      } else {
        print("Error: ${response.statusCode}");
        print(response.body);
        // Show error toast/snackbar
      }
    } catch (e) {
      isloading.value = false;
      print("Exception occurred: $e");
    }
  }
}
