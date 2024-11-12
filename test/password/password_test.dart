import 'package:mvl_desafio/password.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Password validates ',
    () {
      test(
        'the array has only valid passwords',
        () {
          const List<String> list = <String>[
            '#eforTe1',
            'Voce@Consegue!2024',
            'A8fd10e8-4194-488d-aa8b-e53f6a044802',
            'kygjok-xuQxih-coqmu2'
          ];

          for (final String item in list) {
            expect(Password.validate(item), equals(isEmpty));
          }
        },
      );

      test(
        'the array has only invalid passwords',
        () {
          const List<String> list = <String>[
            '',
            'senhafraca',
            'a8fd10e8-4194-488d-aa8b-e53f6a044802',
            'Qu@s1'
          ];

          for (final String item in list) {
            expect(Password.validate(item), equals(isNotEmpty));
          }
        },
      );
    },
  );

  group(
    'Password generate random ',
    () {
      test(
        'should generate valid results',
        () {
          final String random = Password.generateRandom();

          expect(Password.validate(random), equals(isEmpty));
        },
      );
    },
  );
}
