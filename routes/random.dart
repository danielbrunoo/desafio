import 'package:dart_frog/dart_frog.dart';
import 'package:desafio_shared/shared.dart';
import 'package:mvl_desafio/extension/context_ext.dart';
import 'package:mvl_desafio/password.dart';

/// @Allow(GET)
Future<Response> onRequest(RequestContext context) async {
  context.validateMethod(HttpMethod.get);

  return Response.json(
    body: RandomResponse(
      password: Password.generateRandom(),
    ),
  );
}
