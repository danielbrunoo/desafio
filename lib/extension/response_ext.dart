import 'package:dart_frog/dart_frog.dart';

extension ResponseExt on Response {
  Response updateHeader(String key, String value) {
    final Map<String, String> newHeaders = Map<String, String>.of(headers);
    newHeaders[key] = value;

    return copyWith(headers: newHeaders);
  }
}
