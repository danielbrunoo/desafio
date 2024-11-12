import 'dart:io';

import 'app_exception.dart';

final class MethodNotAllowedException extends AppException {
  @override
  int get statusCode => HttpStatus.methodNotAllowed;
}
