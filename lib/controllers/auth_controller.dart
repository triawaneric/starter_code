
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:map_exam/controllers/user_controller.dart';
import 'package:map_exam/moduls/home/home_screen.dart';
import 'package:map_exam/moduls/login/login_screen.dart';
import 'package:map_exam/services/database_service.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final FirebaseAuth auth = FirebaseAuth.instance;
  late Rx<User?> firebaseUser;

  User? get user => firebaseUser.value;

  @override
  void onInit() {
    super.onInit();
    Get.put(UserController());
  }

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, setInitialScreen);
  }

  setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() =>const  LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }


  void login(String email, password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      Get.find<UserController>().user =
      await DatabaseService().getUser(userCredential.user!.uid);
    } catch (e) {
      print(e);
    }
  }

  void logout() async {
    await auth.signOut();
    Get.find<UserController>().clear();
  }
}