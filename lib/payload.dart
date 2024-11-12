import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:desafio_shared/shared.dart';

class Payload {
  Payload({
    required this.body,
    required this.bodyJson,
  });

  factory Payload.empty() => Payload(body: null, bodyJson: null);

  final String? body;
  final Json? bodyJson;

  Json toJson() {
    final Json? bodyJson = this.bodyJson;
    if (bodyJson != null) {
      return bodyJson;
    }

    final String? body = this.body;
    if (body != null) {
      return <String, dynamic>{'string': body};
    }
    return <String, dynamic>{};
  }

  static Future<Payload> fromRequest(RequestContext context) async {
    try {
      final String body = await context.request.body();

      return Payload(
        body: body,
        bodyJson: await jsonDecode(body) as Json,
      );
    } catch (e) {
      return Payload(body: null, bodyJson: null);
    }
  }
}
