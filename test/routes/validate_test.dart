import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:desafio_shared/shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mvl_desafio/exceptions/method_not_allowed.dart';
import 'package:mvl_desafio/payload.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../../routes/validate.dart' as route;

final Uri _uri = Uri.http('localhost', '/validate');

class _MockGetRequestContext extends Mock implements RequestContext {
  @override
  Request get request => Request.get(_uri);
}

class _MockPostValidPayloadRequestContext extends Mock
    implements RequestContext {
  @override
  Request get request => Request.post(
        _uri,
        body: json.encode(
          const PasswordValidatorRequest(password: 'password').toJson(),
        ),
      );
}

class _MockPostValidPasswordRequestContext extends Mock
    implements RequestContext {
  @override
  Request get request => Request.post(
        _uri,
        body: json.encode(
          const PasswordValidatorRequest(
            password: 'Str0ng@Password',
          ).toJson(),
        ),
      );
}

class _MockPostEmptyRequestContext extends Mock implements RequestContext {
  @override
  Request get request => Request.post(
        _uri,
        body: '{}',
      );
}

class _MockPostNullRequestContext extends Mock implements RequestContext {
  @override
  Request get request => Request.post(_uri);
}

class _MockPutRequestContext extends Mock implements RequestContext {
  @override
  Request get request => Request.put(_uri);
}

void main() {
  group(
    '/validate should only accept POST, ',
    () {
      test('GET must throw an MethodNotAllowedException', () async {
        final _MockGetRequestContext context = _MockGetRequestContext();

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
    '/validate should validate body',
    () {
      test(
        'not accept empty payload',
        () async {
          final _MockPostEmptyRequestContext context =
              _MockPostEmptyRequestContext();

          final Response response = await route.onRequest(context);
          expect(response.statusCode, HttpStatus.unprocessableEntity);
        },
      );

      test(
        'not accept null payload',
        () async {
          final _MockPostNullRequestContext context =
              _MockPostNullRequestContext();

          final Response response = await route.onRequest(context);
          expect(response.statusCode, HttpStatus.unprocessableEntity);
        },
      );
    },
  );

  group(
    '/validate should',
    () {
      test(
        'accept valid request but return bad request when is invalid password',
        () async {
          final _MockPostValidPayloadRequestContext context =
              _MockPostValidPayloadRequestContext();

          when(() => context.read<Future<Payload>>()).thenAnswer(
            (_) => Payload.fromRequest(context),
          );

          final Response response = await route.onRequest(context);

          expect(response.statusCode, HttpStatus.badRequest);

          final dynamic body = await response.json();
          expect(body, equals(isA<Json>()));

          final ErrorResponse result = ErrorResponse.fromJson(body as Json);
          expect(result.errorMessage, equals('Senha inválida!'));
          expect(result.errors, equals(isNotEmpty));
        },
      );

      test(
        'accept and return success request',
        () async {
          final _MockPostValidPasswordRequestContext context =
              _MockPostValidPasswordRequestContext();

          when(() => context.read<Future<Payload>>()).thenAnswer(
            (_) => Payload.fromRequest(context),
          );

          final Response response = await route.onRequest(context);

          expect(response.statusCode, HttpStatus.accepted);

          final dynamic body = await response.json();
          expect(body, equals(isA<Json>()));

          final SuccessResponse result = SuccessResponse.fromJson(body as Json);
          expect(Uuid.isValidUUID(fromString: result.id), equals(isTrue));
          expect(result.message, equals('Senha válida!'));
        },
      );
    },
  );
}
