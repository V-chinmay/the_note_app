import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:the_note_app/app/data/models/note_model.dart';
import 'package:the_note_app/app/modules/home/views/NoteTile.dart';
import 'package:the_note_app/app/modules/note_edit/views/note_edit_view.dart';
import 'package:the_note_app/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'elevated_note_action_button.dart';

class HomeView extends GetView<HomeController> {
  
  void onAddNewNote() {
    Get.toNamed(Routes.NOTE_EDIT,arguments: {"note":Note(),"isNewNote":true});
  }

  AppBar get _appBar => AppBar(
          title: Text(
            'Notes',
            style: Get.theme.appBarTheme.titleTextStyle,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            ElevatedNoteActionButton(icon: Icons.search, onPressed: () => null),
          ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar,
        floatingActionButton: FloatingActionButton(
          onPressed: onAddNewNote,
          child: Icon(Icons.add),
        ),
        body: GetBuilder<HomeController>(
          initState: (_) {
            
          },
          builder: (_) {
            return controller.notesList.isEmpty
                ? Center(
                    child: Text("There no notes yet!"),
                  )
                : MasonryGridView.count(
                    padding: EdgeInsets.all(20),
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    itemCount: controller.notesList.length,
                    itemBuilder: (_, index) => InkWell(
                        onTap: () {
                          Get.toNamed(Routes.NOTE_EDIT,arguments: {"note":controller.notesList[index],"isNewNote":false});
                        },
                        child: NoteTile(
                            controller.notesList[index].title!,
                            controller.notesList[index].lastModifiedDate ??
                                DateTime.now(),
                            ((index % 5 + 1) * 100))));
          },
        ));
  }
}
