import 'package:dart_frog/dart_frog.dart';
import 'package:mvl_desafio/extension/context_ext.dart';

/// @Allow(*)
Response onRequest(RequestContext context) {
  return Response(
    statusCode: 201,
    headers: <String, String>{'ip': context.ip},
  );
}
