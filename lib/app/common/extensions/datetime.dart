import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

extension FormattedStringHelpers on DateTime {
  String formattedDateString() {
    return DateFormat.yMMMMd().format(this);
  }
}
