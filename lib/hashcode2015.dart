// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The hashcode2015 library.
library hashcode2015;

String compute(String input) {
  return input;
}

List<Installation> optimize(
    DataCenter dc, List<Machine> machines, List<Group> groups) {
  machines.sort((m1, m2) => m1.slots.compareTo(m2.slots));
  int currentRow = 0;
  for (final m in machines) {
    for (int i = 0; i < dc.rows; i++) {
      dc.putOnRow(currentRow, m);
      currentRow = (currentRow + 1) % dc.rows;
    }
  }
  return dc.installations;
}

class Machine {
  final int id, slots, capacity;

  Machine(this.id, this.slots, this.capacity);

  String toString() => 'id:$id slots:$slots capacity:$capacity';
}

final UNAVAILABLE = new Machine(null, 1, null);

class Group {
  final int id;

  Group(this.id);
}

class DataCenter {
  final List<List<Machine>> slots;

  DataCenter(int rows, int rowSize)
      : slots = new List.generate(rows, (_) => new List<Machine>(rowSize));

  int get rows => slots.length;
  int get slotsByRow => slots[0].length;

  bool putOnRow(int row, Machine m) {
    for (int i = 0; i < slotsByRow; i++) {
      final pos = i;
      for (; i < pos + m.slots; i++) {
        final other = slots[row][i];
        if (other != null) {
          i += other.slots;
          break;
        }
        put(row, pos, m);
        return true;
      }
    }
    return false;
  }

  void put(int row, int slot, Machine m) {
    assert(slots[row][slot] == null);
    slots[row][slot] = m;
  }

  List<Installation> get installations {
    final result = <Installation>[];
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < slotsByRow; j++) {
        final m = slots[i][j];
        if (m != null && m != UNAVAILABLE) {
          result.add(new Installation(m, new Group(0), i, j));
        }
      }
    }
    return result;
  }

  String toString() => slots.toString();
}

class Installation {
  Machine machine;
  Group group;
  int row, slot;
  Installation(this.machine, this.group, this.row, this.slot);
}
