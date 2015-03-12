// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';

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

  print(dataCenter);
  machines.forEach((m) => print(m));

//  print(hashcode2015.compute(input));
}
