import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

Logger logger = Logger(
  filter: FilterLogs(),
);

class FilterLogs extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return kDebugMode;
  }
}
