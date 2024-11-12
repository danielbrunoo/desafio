import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'exceptions/app_exception.dart';
import 'extension/context_ext.dart';
import 'extension/response_ext.dart';

Middleware mainMiddleware() {
  return (Handler handler) {
    return (RequestContext context) async {
      final Stopwatch watch = Stopwatch()..start();
      Response? response;

      try {
        response = await handler(context);
        response = await context.withDelay(response);

        return response;
      } on AppException catch (e) {
        response = e.response.statusCode >= 500
            ? e.response.updateHeader('intentional_error', 'true')
            : e.response;
        return response;
      } catch (e, s) {
        context.logger.error(e, s);

        response = Response.json(
          statusCode: HttpStatus.internalServerError,
          headers: <String, String>{'intentional_error': 'false'},
        );
        return response;
      } finally {
        watch.stop();
        context.logger.logRequest(context, response, watch.elapsed);
      }
    };
  };
}
