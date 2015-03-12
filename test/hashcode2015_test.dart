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

  test('allocation of 2 machines', () {
    final dc = new DataCenter(3, 3);
    final machines = new List.generate(2, (i) => new Machine(i, i + 1, 1));
    expect(optimize1(dc, machines, []).join('\n'), '''
Installation[machine:[Machine[id:0 slots:1 capacity:1]] row:1 slot:0 group:Group[id:0]]
Installation[machine:[Machine[id:1 slots:2 capacity:1]] row:0 slot:0 group:Group[id:0]]''');
  });

  test('allocation of too many machines', () {
    final dc = new DataCenter(2, 3);
    final machines = new List.generate(3, (i) => new Machine(i, 2, 1));
    expect(optimize1(dc, machines, []).join('\n'), '''
Installation[machine:[Machine[id:0 slots:2 capacity:1]] row:0 slot:0 group:Group[id:0]]
Installation[machine:[Machine[id:1 slots:2 capacity:1]] row:1 slot:0 group:Group[id:0]]''');
  });

  test('allocations with an unavailable', () {
    final dc = new DataCenter(1, 5);
    dc.put(0, 1, UNAVAILABLE);
    final machines = new List.generate(3, (i) => new Machine(i, 2, 1));
    expect(optimize1(dc, machines, []).join('\n'), '''
Installation[machine:[Machine[id:0 slots:2 capacity:1]] row:0 slot:2 group:Group[id:0]]''');
  });

  test('allocations with an unavailable', () {
    final dc = new DataCenter(1, 5);
    final machines = new List.generate(3, (i) => new Machine(i, 7 - i, 1));
    expect(optimize1(dc, machines, []).join('\n'), '''
Installation[machine:[Machine[id:2 slots:5 capacity:1]] row:0 slot:0 group:Group[id:0]]''');
  });

  skip_test('allocation of 2 machines with groups', () {
    final dc = new DataCenter(3, 3);
    final machines = new List.generate(4, (i) => new Machine(i, 1, 1));
    final groups = new List.generate(2, (i) => new Group(i));
    expect(optimize1(dc, machines, groups).join('\n'), '''
Installation[machine:[Machine[id:0 slots:1 capacity:1]] row:0 slot:0 group:Group[id:0]]
Installation[machine:[Machine[id:1 slots:1 capacity:1]] row:1 slot:0 group:Group[id:1]]
Installation[machine:[Machine[id:2 slots:1 capacity:1]] row:2 slot:0 group:Group[id:0]]
Installation[machine:[Machine[id:3 slots:1 capacity:1]] row:0 slot:1 group:Group[id:1]]''');
  });
}
