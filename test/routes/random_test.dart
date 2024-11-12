import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:desafio_shared/shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mvl_desafio/exceptions/method_not_allowed.dart';
import 'package:mvl_desafio/password.dart';
import 'package:test/test.dart';

import '../../routes/random.dart' as route;

final Uri _uri = Uri.http('localhost', '/random');

class _MockGetRequestContext extends Mock implements RequestContext {
  @override
  Request get request => Request.get(_uri);
}

class _MockPostRequestContext extends Mock implements RequestContext {
  @override
  Request get request => Request.post(_uri);
}

class _MockPutRequestContext extends Mock implements RequestContext {
  @override
  Request get request => Request.put(_uri);
}

void main() {
  group(
    '/random should only accept GET, ',
    () {
      test('POST must throw an MethodNotAllowedException', () async {
        final _MockPostRequestContext context = _MockPostRequestContext();

        expectLater(
          route.onRequest(context),
          throwsA(isA<MethodNotAllowedException>()),
        );
      });

      test(
        'PUT must throw an MethodNotAllowedException',
        () async {
          final _MockPutRequestContext context = _MockPutRequestContext();

          expectLater(
            route.onRequest(context),
            throwsA(isA<MethodNotAllowedException>()),
          );
        },
      );
    },
  );

  group(
    '/random should ',
    () {
      test(
        'return valid password',
        () async {
          final _MockGetRequestContext context = _MockGetRequestContext();

          final Response response = await route.onRequest(context);
          expect(response.statusCode, HttpStatus.ok);
          final dynamic body = await response.json();
          expect(body, equals(isA<Json>()));

          final RandomResponse result = RandomResponse.fromJson(body as Json);
          expect(Password.validate(result.password), equals(isEmpty));
        },
      );
    },
  );
}
