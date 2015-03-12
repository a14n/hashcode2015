// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library hashcode2015_test;

import 'package:hashcode2015/hashcode2015.dart';
import 'package:unittest/unittest.dart';

void main() => defineTests();

void defineTests() {
  group('main tests', () {
    test('calculate', () {
      expect(compute('test'), 'test');
    });
  });
}
