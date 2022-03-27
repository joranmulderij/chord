import 'package:chord/frettable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chord/chord.dart';

void main() {
  test('test', () {
    expect(Chord('C#m7sus2').getPitches(), {0, 2, 7, 10});
  });
}
