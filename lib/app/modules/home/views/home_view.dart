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
    Get.toNamed(Routes.NOTE_EDIT,
        arguments: {"note": Note(), "isNewNote": true});
  }

  AppBar _appBar(bool isInSearchMode) => AppBar(
          title: Text(
            'Notes',
            style: Get.theme.appBarTheme.titleTextStyle,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            if (controller.isSearchingMode.value)
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller.queryEditingController,
                  onChanged: controller.onQueryChanged,
                  decoration: InputDecoration(
                      hintText: "search something...",
                      suffix: IconButton(
                          onPressed: () {
                            controller.queryEditingController.clear();
                            controller.onQueryChanged(null);
                          },
                          icon: Icon(Icons.cancel_sharp))),
                ),
              )),
            if (!controller.isSearchingMode.value)
              ElevatedNoteActionButton(
                  icon: Icons.search,
                  onPressed: () => controller.isSearchingMode.value = true),
          ]);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: _appBar(controller.isSearchingMode.value),
        floatingActionButton: FloatingActionButton(
          onPressed: onAddNewNote,
          child: Icon(Icons.add),
        ),
        body: GestureDetector(
          onTap: () {
            controller.toggleSearchingMode();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: GetBuilder<HomeController>(
            initState: (_) {},
            builder: (_) {
              List<Note> noteList = controller.isSearchingMode.value
                  ? controller.filteredNotesList
                  : controller.notesList;
              return controller.notesList.isEmpty
                  ? Center(
                      child: Text("There no notes yet!"),
                    )
                  : MasonryGridView.count(
                      padding: EdgeInsets.all(20),
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      itemCount: noteList.length,
                      itemBuilder: (_, index) => InkWell(
                          onTap: () {
                            controller.toggleSearchingMode();
                            Get.toNamed(Routes.NOTE_EDIT, arguments: {
                              "note": noteList[index],
                              "isNewNote": false
                            });
                          },
                          child: NoteTile(
                              noteList[index].title!,
                              noteList[index].timeStampDate ??
                                  DateTime.now(),
                              ((index % 5 + 1) * 100))));
            },
          ),
        )));
  }
}
