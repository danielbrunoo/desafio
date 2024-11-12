extension UriExt on Uri {
  String get fullPath => '$path$queryString';
  String get queryString => query.isEmpty ? '' : '?$query';
}
