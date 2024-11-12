// ignore_for_file: avoid_print

import 'package:dart_frog/dart_frog.dart';
import 'package:intl/intl.dart';

import 'extension/context_ext.dart';
import 'extension/uri_ext.dart';
import 'save_author.dart';

class AppLogger {
  void info(String message) {
    print(message);
  }

  void error(Object e, [StackTrace? s]) {
    print(e);
    print(s);
  }

  void logRequest(
    RequestContext context,
    Response? response,
    Duration elapsedTime,
  ) {
    final Request request = context.request;

    final String time = DateFormat('dd-MM HH:mm:ss').format(DateTime.now());

    final String method =
        '[${request.method.name.toUpperCase()} ${response?.statusCode}]'
            .padLeft(13);

    print(
      '$time $method '
      '${context.ip.padLeft(10)} '
      '${elapsedTime.inMilliseconds.toString().padLeft(4)}ms '
      '${context.request.uri.fullPath}',
    );

    saveAuthor(context, response, elapsedTime).ignore();
  }
}
