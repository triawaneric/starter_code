import 'package:get/get.dart';
import 'package:map_exam/controllers/auth_controller.dart';
import 'package:map_exam/models/note.dart';
import 'package:map_exam/services/database_service.dart';

class NoteController extends GetxController {
  static NoteController instance = Get.find();

  Rx<List<Note>> noteList = Rx<List<Note>>([]);
  List<Note> get notes => noteList.value;



  @override
  void onInit() {
    super.onInit();
    String uid = Get.find<AuthController>().user!.uid;
    noteList.bindStream(DatabaseService().noteStream(uid));
  }

}