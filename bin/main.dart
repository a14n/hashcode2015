// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:math';

import 'package:hashcode2015/hashcode2015.dart';

class Info {
  final int rows, rowSize, indispoSize, groups, servers;

  Info(this.rows, this.rowSize, this.indispoSize, this.groups, this.servers);

  toString() => "$rows rows, $rowSize rowSize, $indispoSize..";
}

main(List<String> args) {
  final allLines = new File(args[0]).readAsLinesSync();

  final firstLine = allLines[0].split(" ").map((s) => int.parse(s)).toList();
  final info = new Info(
      firstLine[0], firstLine[1], firstLine[2], firstLine[3], firstLine[4]);

  final dataCenter = new DataCenter(info.rows, info.rowSize);
  allLines
      .getRange(1, info.indispoSize + 1)
      .map((f) => f.split(" ").map((p) => int.parse(p)).toList())
      .forEach((f) => dataCenter.put(f[0], f[1], UNAVAILABLE));

  int i = 0;
  final machines = allLines
      .skip(info.indispoSize + 1)
      .map((f) => f.split(" ").map((p) => int.parse(p)).toList())
      .map((f) => new Machine(i++, f[0], f[1]))
      .toList();

//  print(dataCenter);
//  machines.forEach((m) => print(m));

  final optim = optimize1(dataCenter, machines,
          new Iterable.generate(info.groups).map((i) => new Group(i)).toList())
      .where((i) => i.machine != UNAVAILABLE)
      .toList();

  optim.sort((i1, i2) => i1.machine.id - i2.machine.id);

  showMe(machines, optim);

  //scoreUp(optim, dataCenter);
  //scoreLow(optim, dataCenter, new Iterable.generate(info.groups).map((i) => new Group(i)).toList());

  final finalScore = score(optim, dataCenter,
      new Iterable.generate(info.groups).map((i) => new Group(i)).toList());
  print("Score $finalScore");
}

int score(List<Installation> optim, DataCenter dataCenter, List<Group> groups) {
  Map<Group, int> scores = scoreLow(optim, dataCenter, groups);
  print(scores);
  return scores.values.fold(20000000, (o, s) => min(o, s));
}

Map<Group, int> scoreLow(
    List<Installation> optim, DataCenter datacenter, List<Group> groups) {
  Map<Group, int> map = new Map();
  for (int r = 0; r < datacenter.rows; r++) {
    final t = new Map.fromIterable(groups,
        value: (g) => optim
            .where((i) => i.row != r)
            .where((i) => i.group.id == g.id)
            .fold(0, (c, i) => c + i.machine.capacity));
    print('$t');
    t.forEach((g, s) {
      if (!map.containsKey(g)) {
        map[g] = s;
      } else {
        map[g] = min(s, map[g]);
      }
    });
  }

//  map.forEach((g, s) => print("score du group ${g.id} => $s"));

  groups.forEach((g) => map.putIfAbsent(g, () => 0));
  return map;
}

void showMe(List<Machine> machines, List<Installation> optim) {
  machines.sort((m1, m2) => m1.id - m2.id);
  for (Machine machine in machines) {
    final result =
        optim.firstWhere((i) => i.machine.id == machine.id, orElse: () => null);
    if (result == null) {
      print("x");
    } else {
      //      print("${result.row} ${result.slot} ${result.group.id}");
      print("${result.row} ${result.slot} ${result.group.id}");
    }
  }
}
