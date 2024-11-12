import 'dart:math';

import 'package:dart_frog/dart_frog.dart';

import '../app_logger.dart';
import '../exceptions/method_not_allowed.dart';
import '../exceptions/random_error.dart';
import '../payload.dart';
import 'response_ext.dart';

extension ContextExt on RequestContext {
  AppLogger get logger => read<AppLogger>();
  Future<Payload> get payload => read<Future<Payload>>();

  String get ip =>
      request.headers['x-forwarded-for'] ??
      request.connectionInfo.remoteAddress.address;

  void validateMethod(HttpMethod methodAccepted) {
    if (request.method != methodAccepted) {
      throw MethodNotAllowedException();
    }
  }

  Future<Response> withDelay(Response response) async {
    const List<String> delayRoutes = <String>['/validate', '/random'];

    final String path = request.uri.path;
    if (delayRoutes.contains(path) && request.headers['no-delay'] == null) {
      final Duration delayDuration = Duration(seconds: Random().nextInt(6));

      await Future<void>.delayed(delayDuration, _randomError);

      return response.updateHeader('delayed', '${delayDuration.inSeconds}s');
    }

    return response;
  }

  void _randomError() {
    final Random r = Random();

    if (r.nextBool() && r.nextBool() && r.nextBool()) {
      throw RandomErrorException();
    }
  }
}
