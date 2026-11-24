String ruCount(int count, String one, String few, String many) {
  final mod10 = count % 10;
  final mod100 = count % 100;
  if (mod10 == 1 && mod100 != 11) {
    return '$count $one';
  }
  if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
    return '$count $few';
  }
  return '$count $many';
}

String examAllowance(int allowed) {
  if (allowed <= 0) {
    return 'без ошибок';
  }
  return 'допуск ${ruCount(allowed, 'ошибка', 'ошибки', 'ошибок')}';
}
