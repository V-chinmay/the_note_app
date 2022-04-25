import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteTile extends StatelessWidget {
  const NoteTile(this.noteTitle, this.lastModifiedDate, this.extent, {Key? key})
      : super(key: key);
  final String noteTitle;
  final DateTime lastModifiedDate;
  final double extent;

  Color getColorFromTitle(String title) =>
      Color((title.hashCode - (title.length * title.length)) & 0xffffffff);
  String getFormattedDateString(DateTime date) =>
      DateFormat.yMMMMd().format(date);

  @override
  Widget build(BuildContext context) {
    print("colors is ${getColorFromTitle(noteTitle)}");
    return Container(
      width: this.extent,
      height: this.extent,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: getColorFromTitle(noteTitle),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow()]),
      child: Column(children: [
        Expanded(
          flex: 2,
          child: Text(
            noteTitle,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.grey),
            overflow: TextOverflow.fade,
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            getFormattedDateString(this.lastModifiedDate),
            style: Theme.of(context).textTheme.subtitle1,
          ),
        )
      ]),
    );
  }
}
