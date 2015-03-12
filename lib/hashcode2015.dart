// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The hashcode2015 library.
library hashcode2015;

String compute(String input) {
  return input;
}

class Machine {
  final int id, slots, capacity;

  Machine(this.id, this.slots, this.capacity);
}

final UNAVAILABLE = new Machine(null, null, null);

class Group {
  final int id;

  Group(this.id);
}

class DataCenter {
  final List<List<Machine>> slots;

  DataCenter(int rows, int rowSize)
      : slots = new List.generate(rows, (_) => new List<Machine>(rowSize));

  void put(int row, int slot, Machine m) {
    slots[row][slot] = m;
  }
}

class Installation {
  Machine machine;
  Group group;
  int row, slot;
  Installation(this.machine, this.group, this.row, this.slot);
}
