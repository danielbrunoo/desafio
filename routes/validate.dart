import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:desafio_shared/shared.dart';
import 'package:mvl_desafio/extension/context_ext.dart';
import 'package:mvl_desafio/password.dart';
import 'package:uuid/uuid.dart';

/// @Allow(POST)
Future<Response> onRequest(RequestContext context) async {
  context.validateMethod(HttpMethod.post);

  late final String passwordRequest;

  try {
    final Json? body = (await context.payload).bodyJson;

    if (body == null) {
      return Response.json(
        statusCode: HttpStatus.unprocessableEntity,
        body: ErrorResponse(errorMessage: 'Missing payload request'),
      );
    }

    final PasswordValidatorRequest request =
        PasswordValidatorRequest.fromJson(body);
    passwordRequest = request.password;
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.unprocessableEntity,
      body: ErrorResponse(
          errorMessage: 'Request body is not parseable, '
              'check out the `PasswordValidatorRequest` object'),
    );
  }

  final List<String> errors = Password.validate(passwordRequest);

  if (errors.isEmpty) {
    return Response.json(
      statusCode: HttpStatus.accepted,
      body: SuccessResponse(
        id: const Uuid().v4(),
        message: 'Senha válida!',
      ),
    );
  }

  return Response.json(
    statusCode: HttpStatus.badRequest,
    body: ErrorResponse(
      errorMessage: 'Senha inválida!',
      errors: errors,
    ),
  );
}
