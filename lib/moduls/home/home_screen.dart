import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_exam/controllers/auth_controller.dart';
import 'package:map_exam/controllers/note_controller.dart';
import 'package:map_exam/controllers/user_controller.dart';

class HomeScreen extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (_) => HomeScreen());
  HomeScreen({Key? key}) : super(key: key);

  AuthController authController = AuthController.instance;
  final userController = Get.put(UserController());
  final noteController = Get.put(NoteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade200,
            child: Obx(()=> Text(
                '${noteController.noteList.value.length}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0)),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body:GetX<NoteController>(
        builder: (NoteController noteController) {
          if (noteController != null && noteController.notes != null) {
            return ListView.separated(
              itemCount: noteController.noteList.value.length,
              separatorBuilder: (context, index) => const Divider(
                color: Colors.blueGrey,
              ),
              itemBuilder: (context, index) => ListTile(
                trailing: Visibility(
                  visible: false,
                  child: SizedBox(
                    width: 110.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.blue,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                title: Text("${noteController.noteList.value[index].title}"),
                subtitle:Text('${noteController.noteList.value[index].content}'),
                onTap: () {},
                onLongPress: () {},
              ),
            );
          } else {
            return const Text('loading....');
          }
        }
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              heroTag: UniqueKey(),
              child: const Icon(Icons.menu),
              tooltip: 'Show less. Hide notes content',
              onPressed: () {}),

          /* Notes: for the "Show More" icon use: Icons.menu */

          FloatingActionButton(
            heroTag: UniqueKey(),
            child: const Icon(Icons.add),
            tooltip: 'Add a new note',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
