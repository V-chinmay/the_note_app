import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:the_note_app/app/modules/home/views/NoteTile.dart';

import '../controllers/home_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeView extends GetView<HomeController> {
  void onAddNewNote() {}

  AppBar get _appBar => AppBar(
          title: Text(
            'Notes',
            style: Get.theme.appBarTheme.titleTextStyle,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Container(
              margin: EdgeInsets.only(top: 8, right: 16),
              child: ElevatedButton(
                onPressed: () => null,
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.grey.shade800)),
                child: Icon(
                  Icons.search,
                ),
              ),
            ),
          ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar,
        floatingActionButton: FloatingActionButton(
          onPressed: onAddNewNote,
          child: Icon(Icons.add),
        ),
        body: MasonryGridView.count(
            padding: EdgeInsets.all(20),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            itemCount: 20,
            itemBuilder: (_, index) => NoteTile(
                List.generate(index + 1, (index) => "Something,Something,")
                    .join(":"),
                DateTime.now().subtract(Duration(days: index)),
                (index % 5 + 1) * 100)));
  }
}
