import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:the_note_app/app/common/views/app_loading_view.dart';
import 'package:the_note_app/app/common/views/info_snackbar_view.dart';
import 'package:the_note_app/app/modules/home/controllers/home_controller.dart';
import 'package:the_note_app/app/modules/home/views/elevated_note_action_button.dart';

import '../controllers/note_edit_controller.dart';

class NoteEditView extends GetView<NoteEditController> {
  NoteEditView() {
    controller.controllerStateStream.listen((event) {
      switch (event) {
        case ControllerState.success:
          AppLoadingView.dismiss();
          break;
        case ControllerState.loading:
          AppLoadingView.show();
          break;
        case ControllerState.failure:
          AppLoadingView.dismiss();
          break;
        default:
      }
    });
  }

  void onEditButtonPressed() async {
    if (controller.isEditingMode.value) {
      await controller.updateNote();
    }
    if (controller.isNewNote) {
      Get.back();
      return;
    }
    controller.isEditingMode.toggle();
  }

  void onDeleteButtonPressed() async {
    await controller.deleteNote();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Obx(
        () => CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: ElevatedNoteActionButton(
                onPressed: Get.back,
                icon: Icons.chevron_left,
              ),
              actions: [
                ElevatedNoteActionButton(
                    onPressed: onDeleteButtonPressed, 
                    icon: Icons.delete
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedNoteActionButton(
                    onPressed: (controller.isASaveableEdit.isFalse && controller.isEditingMode.isTrue) ? 
                    null:
                    onEditButtonPressed ,
                    icon: controller.isEditingMode.value
                        ? Icons.check
                        : Icons.edit_outlined)
              ],
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.none,
                titlePadding: EdgeInsets.zero,
                title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: controller.titleEditingController,
                        textAlign: TextAlign.start,
                        maxLength: controller.TITLE_MAX_LENGTH,
                        onChanged: (value) => this.controller.isASaveableEdit.value = !value.isEmpty,
                        decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none, 
                            hintText: "Title"
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: Colors.white),
                        enabled: controller.isEditingMode.value,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          controller.lastModifiedDate,
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: Colors.grey),
                        ),
                      )
                    ]),
              ),
            ),
            SliverFillRemaining(
                child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SingleChildScrollView(
                  child: TextField(
                controller: controller.descriptionEditingController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "Type something here..."),
                enabled: controller.isEditingMode.value,
              )),
            ))
          ],
        ),
      ),
    ));
  }
}
