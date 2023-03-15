import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_exam/controllers/auth_controller.dart';
import 'package:map_exam/controllers/note_controller.dart';
import 'package:map_exam/controllers/user_controller.dart';
import 'package:map_exam/moduls/edit/edit_screen.dart';
import 'package:map_exam/services/database_service.dart';

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

          IconButton(
              onPressed: (){
                //Logout
                authController.logout();

              },
              icon: Icon(Icons.exit_to_app)
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
                trailing:Obx(()=> index == noteController.selectedIdx.value  ?   SizedBox(
                  width: 110.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Get.to(
                            const EditScreen(),
                            arguments: [
                              {'titleBar':'Edit Note'},
                              {'contentId':'${noteController.noteList.value[index].id}',},
                              {'contentTitle':'${noteController.noteList.value[index].title}',},
                              {'contentDesc':'${noteController.noteList.value[index].content}',}
                            ],
                            transition: Transition.downToUp,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          DatabaseService().deleteData(
                              noteController.noteList.value[index].id.toString()
                              ,authController.user!.uid.toString());
                        },
                      ),
                    ],
                  ),
                ): Visibility(visible: false,child: Container()),
                ),


                title: Text("${noteController.noteList.value[index].title}"),
                subtitle: Obx(()=>Visibility(
                    visible: noteController.isVisibleSubtitle.value,
                    child: Text('${noteController.noteList.value[index].content}')
                  ),
                ),
                onTap: () {
                  Get.to(const EditScreen(),
                    arguments: [
                      {'titleBar':'View Mode'},
                      {'contentId':'${noteController.noteList.value[index].id}',},
                      {'contentTitle':'${noteController.noteList.value[index].title}',},
                      {'contentDesc':'${noteController.noteList.value[index].content}',}
                    ],
                    transition: Transition.downToUp,
                  );
                },
                onLongPress: () {
                  if(noteController.isVisibleAction.isFalse){
                    noteController.showContainerByIndex(index);
                  }else{
                    noteController.hideContainerByIndex(index);
                  }
                },
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
              child: Obx(()=>noteController.isVisibleSubtitle.value ? const Icon(Icons.unfold_less): const Icon(Icons.menu)),
              tooltip: 'Show less. Hide notes content',
              onPressed: () {
                if(noteController.isVisibleSubtitle.isFalse){
                  noteController.showSubtitle();
                  print("long press item show");
                }else{
                  noteController.hideSubtitle();
                  print("long press item hide");
                }
              }
          ),
          /* Notes: for the "Show More" icon use: Icons.menu */

          FloatingActionButton(
            heroTag: UniqueKey(),
            child: const Icon(Icons.add),
            tooltip: 'Add a new note',
            onPressed: () {
              Get.to(const EditScreen(),
                arguments: [
                  {'titleBar':'Add New Note'},
                  {'contentId':''},
                  {'contentTitle':''},
                  {'contentDesc':''}
                ],
                transition: Transition.downToUp,
              );
            },
          ),
        ],
      ),
    );
  }
}
