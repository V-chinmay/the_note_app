import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:the_note_app/app/modules/home/views/elevated_note_action_button.dart';

import '../controllers/note_edit_controller.dart';

class NoteEditView extends GetView<NoteEditController> {
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
                    onPressed: onDeleteButtonPressed, icon: Icons.delete),
                SizedBox(
                  width: 10,
                ),
                ElevatedNoteActionButton(
                    onPressed: onEditButtonPressed,
                    icon: controller.isEditingMode.value
                        ? Icons.check
                        : Icons.edit_outlined)
              ],
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                titlePadding: EdgeInsets.zero,
                title: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: controller.titleEditingController,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(border: InputBorder.none),
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
                      decoration: InputDecoration(border: InputBorder.none),
                      enabled: controller.isEditingMode.value)),
            ))
          ],
        ),
      ),
    ));
  }
}
