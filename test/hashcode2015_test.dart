// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library hashcode2015_test;

import 'package:hashcode2015/hashcode2015.dart';
import 'package:unittest/unittest.dart';

void main() => defineTests();

void defineTests() {
  test('allocation of 1 machine', () {
    final dc = new DataCenter(3, 3);
    final machines = new List.generate(1, (i) => new Machine(i, 1, 1));
    expect(optimize1(dc, machines, []).join('\n'), '''
Installation[machine:[Machine[id:0 slots:1 capacity:1]] row:0 slot:0 group:Group[id:0]]''');
  });
  test('allocation of 2 machines', () {
    final dc = new DataCenter(3, 3);
    final machines = new List.generate(2, (i) => new Machine(i, 1, 1));
    expect(optimize1(dc, machines, []).join('\n'), '''
Installation[machine:[Machine[id:0 slots:1 capacity:1]] row:0 slot:0 group:Group[id:0]]
Installation[machine:[Machine[id:1 slots:1 capacity:1]] row:1 slot:0 group:Group[id:0]]''');
  });
  test('allocation of 4 machines', () {
    final dc = new DataCenter(3, 3);
    final machines = new List.generate(4, (i) => new Machine(i, 1, 1));
    expect(optimize1(dc, machines, []).join('\n'), '''
Installation[machine:[Machine[id:0 slots:1 capacity:1]] row:0 slot:0 group:Group[id:0]]
Installation[machine:[Machine[id:1 slots:1 capacity:1]] row:1 slot:0 group:Group[id:0]]
Installation[machine:[Machine[id:2 slots:1 capacity:1]] row:2 slot:0 group:Group[id:0]]
Installation[machine:[Machine[id:3 slots:1 capacity:1]] row:0 slot:1 group:Group[id:0]]''');
  });
}
