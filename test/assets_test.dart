import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('question database, picture and sign are bundled', () async {
    final database = await rootBundle.load(
      'data/open_source_tests1/questions.sqlite',
    );
    final picture = await rootBundle.load(
      'data/open_source_tests1/images/1.45.2.jpg',
    );
    final sign = await rootBundle.load(
      'data/open_source_tests1/by/IMG/signs/2_1.png',
    );
    final medicine = await rootBundle.load(
      'data/open_source_tests1/by/IMG/med/med_700102901.jpg',
    );

    expect(database.lengthInBytes, greaterThan(1000000));
    expect(picture.lengthInBytes, greaterThan(100));
    expect(sign.lengthInBytes, greaterThan(100));
    expect(medicine.lengthInBytes, greaterThan(100));
  });
}
