import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_exam/controllers/auth_controller.dart';
import 'package:map_exam/controllers/note_controller.dart';
import 'package:map_exam/services/database_service.dart';

class EditScreen extends StatefulWidget {


  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController() ;
  late String idContent;

  AuthController authController = AuthController.instance;
  NoteController noteController = NoteController.instance;



  @override
  Widget build(BuildContext context) {
    dynamic argumentData = Get.arguments;


    if(argumentData  != null){
      if(argumentData [0]['titleBar'].toString().toLowerCase().contains("view")){
        noteController.hideButtonCheck();
      }else{
        noteController.showButtonCheck();
      }

      idContent = argumentData [1]['contentId'];
      titleController = TextEditingController(text: argumentData [2]['contentTitle']);
      descriptionController = TextEditingController(text: argumentData [3]['contentDesc']);
    }else{

    }



    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Text(argumentData[0]['titleBar'].toString()),
        actions: [

          Obx(() => Visibility(
            visible: noteController.isEditMode.value ,
            child:IconButton(
                icon: const Icon(
                  Icons.check_circle,
                  size: 30,
                ),
                onPressed: () {
                  if (titleController.text  != '' && descriptionController.text != '') {
                    if(argumentData[0]['titleBar'].toString().toLowerCase().contains("add")){
                      DatabaseService().addNote(titleController.text.trim(),descriptionController.text.trim(),
                          authController.user!.uid);
                      titleController!.clear();
                      descriptionController!.clear();

                      Get.back();

                    }else if(argumentData[0]['titleBar'].toString().toLowerCase().contains("edit")){
                      DatabaseService().updateNote(
                          titleController.text.trim(),
                          descriptionController.text.trim(),
                          authController.user!.uid,
                          idContent
                      );
                      Get.back();
                    }
                  }
                }),
          )
          ),

          IconButton(
              icon: const Icon(
                Icons.cancel_sharp,
                size: 30,
              ),
              onPressed: () {
                Get.back();
              }),
        ],
      ),
      body: GetBuilder<NoteController>(
          init: NoteController(),
          builder: (contex) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    enabled: noteController.isEditMode.value,
                    decoration: const InputDecoration(
                      hintText: 'Type the title here',
                    ),
                    onChanged: (value) {},
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: TextFormField(
                        controller: descriptionController,
                        enabled: noteController.isEditMode.value,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          hintText: 'Type the description',
                        ),
                        onChanged: (value) {
                          print("val "+value);
                        }),
                  ),
                ],
              ),
            );
          }
      ),



    );
  }
}
