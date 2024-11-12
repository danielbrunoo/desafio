import 'package:dart_frog/dart_frog.dart';
import 'package:mvl_desafio/app_logger.dart';
import 'package:mvl_desafio/main_middleware.dart';
import 'package:mvl_desafio/payload.dart';

import 'package:shelf_cors_headers/shelf_cors_headers.dart' as shelf;

Handler middleware(Handler handler) {
  return handler
      .use(mainMiddleware())
      .use(provider<Future<Payload>>(Payload.fromRequest))
      .use(_cors())
      .use(provider<AppLogger>((_) => AppLogger()));
}

Middleware _cors() {
  return fromShelfMiddleware(
    shelf.corsHeaders(
      headers: <String, String>{
        shelf.ACCESS_CONTROL_ALLOW_ORIGIN: '*',
        shelf.ACCESS_CONTROL_ALLOW_CREDENTIALS: '*',
        shelf.ACCESS_CONTROL_ALLOW_HEADERS: '*',
        shelf.ACCESS_CONTROL_ALLOW_METHODS: '*',
      },
    ),
  );
}
