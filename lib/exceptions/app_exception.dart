import 'package:dart_frog/dart_frog.dart';

abstract class AppException implements Exception {
  int get statusCode;
  Object? body;

  Response get response => Response.json(statusCode: statusCode, body: body);
}
