import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class PatientChatController extends GetxController {
  final DatabaseReference db = FirebaseDatabase.instance.ref();

  /// ✅ Realtime message listener
  Stream<DatabaseEvent> listenToMessages(String appointmentId) {
    return db.child("chats/$appointmentId/messages").onValue;
  }

  /// ✅ Send new message
  Future<void> sendMessage({
    required String appointmentId,
    required String senderId,
    required String text,
  }) async {
    final messageRef = db.child("chats/$appointmentId/messages").push();

    await messageRef.set({
      "senderId": senderId,
      "text": text,
      "timestamp": DateTime.now().toIso8601String(),
    });
  }
}
