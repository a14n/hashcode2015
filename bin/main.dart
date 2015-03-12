// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:hashcode2015/hashcode2015.dart' as hashcode2015;

main(List<String> args) {
  final input = new File(args[0]).readAsStringSync();

  print(hashcode2015.compute(input));
}
