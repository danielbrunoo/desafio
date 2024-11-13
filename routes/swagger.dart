import 'package:dart_frog/dart_frog.dart';

/// @Allow(*)
Response onRequest(RequestContext context) {
  return Response.movedPermanently(location: 'https://desafioflutter-api.modelviewlabs.com/swagger.html');
}