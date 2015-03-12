// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/args.dart';
import 'package:hashcode2015/hashcode2015.dart' as hashcode2015;

main(List<String> args) {
  final parser = new ArgParser()..addOption('file', abbr: 'f');

  final result = parser.parse(args);
  final file = result['file'];

  final input = new File(file).readAsStringSync();

  print(hashcode2015.compute(input));
}
