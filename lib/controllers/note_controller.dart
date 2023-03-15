import 'package:get/get.dart';
import 'package:map_exam/controllers/auth_controller.dart';
import 'package:map_exam/models/note.dart';
import 'package:map_exam/services/database_service.dart';

class NoteController extends GetxController {
  static NoteController instance = Get.find();

  Rx<List<Note>> noteList = Rx<List<Note>>([]);
  List<Note> get notes => noteList.value;

  RxBool isVisibleSubtitle = true.obs;
  RxBool isVisibleAction = false.obs;
  RxInt selectedIdx = (-1).obs;

  void showSubtitle() {
    isVisibleSubtitle.value = true;
  }
  void hideSubtitle() {
    isVisibleSubtitle.value = false;
  }

  //Show Hide container listile by index
  void showContainerByIndex(int idx) {
    isVisibleAction.value = true;
    selectedIdx.value = idx ;
  }
  void hideContainerByIndex(int idx) {
    isVisibleAction.value = false;
    selectedIdx.value = -1;

  }






  @override
  void onInit() {
    super.onInit();
    String uid = Get.find<AuthController>().user!.uid;
    noteList.bindStream(DatabaseService().noteStream(uid));
  }

}