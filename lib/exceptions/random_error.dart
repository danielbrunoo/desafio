import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'app_exception.dart';

final class RandomErrorException extends AppException {
  @override
  int get statusCode => HttpStatus.serviceUnavailable;

  @override
  String get body => 'Service is unavailable';

  @override
  Response get response {
    return Response(statusCode: statusCode, body: body);
  }
}
