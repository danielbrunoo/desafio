import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../routes/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group(
    'GET /',
    () {
      test(
        'responds with a 204',
        () {
          final _MockRequestContext context = _MockRequestContext();
          final Response response = route.onRequest(context);
          expect(response.statusCode, equals(HttpStatus.noContent));
          expect(response.body(), completion(isEmpty));
        },
      );
    },
  );
}
