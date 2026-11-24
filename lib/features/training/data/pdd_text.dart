String normalizePddText(String value) {
  return value
      .replaceAll('\u00A0', ' ')
      .replaceAll('\u202F', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

int asInt(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  throw FormatException('Ожидалось целое число, получено $value');
}

String asText(Object? value) {
  if (value is String) {
    return normalizePddText(value);
  }
  return '';
}

String? questionImageAsset(Object? value) {
  if (value is! String) {
    return null;
  }
  final name = value.trim();
  if (name.isEmpty) {
    return null;
  }
  return 'data/open_source_tests1/images/$name';
}
