import 'package:dart_frog/dart_frog.dart';

import 'extension/context_ext.dart';

Future<void> saveAuthor(
  RequestContext context,
  Response? response,
  Duration elapsedTime,
) async {
  try {
    final String? authorHeader = context.request.headers['author'];

    if (authorHeader != null && authorHeader.isNotEmpty) {
      context.logger.info('author: $authorHeader');
    }

    //...
    // context.logger.info('Log saved ${result.id}');
  } catch (e, s) {
    context.logger.error(e, s);
  }
}
