import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:the_note_app/app/modules/home/views/NoteTile.dart';

import '../controllers/home_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Notes',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: MasonryGridView.count(
            padding: EdgeInsets.all(8),
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            itemCount: 20,
            itemBuilder: (_, index) => NoteTile(
                List.generate(index + 1, (index) => "Something,Something,")
                    .join(":"),
                DateTime.now().subtract(Duration(days: index)),
                (index % 5 + 1) * 100)));
  }
}
