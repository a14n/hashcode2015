// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The hashcode2015 library.
library hashcode2015;

String compute(String input) {
  return input;
}

List<Installation> optimize1(
    DataCenter dc, List<Machine> machines, List<Group> groups) {
  machines.sort((m1, m2) => m2.slots.compareTo(m1.slots));
  int currentRow = 0;
  for (final m in machines) {
    for (int i = 0; i < dc.rows; i++) {
      final success = dc.putOnRow(currentRow, m);
      currentRow = (currentRow + 1) % dc.rows;
      if (success) break;
    }
  }

  // group allocations
  final installations = dc.installations;
  installations.sort((i1, i2) => i1.machine.slots
      .compareTo(i2.machine.slots));

  if (groups.isNotEmpty) {
    int groupIndex = 0;
    for (final installation in installations) {
      installation.group = groups[groupIndex];
      groupIndex = (groupIndex + 1) % groups.length;
    }
  }

  installations.sort((i1, i2) => i1.machine.id.compareTo(i2.machine.id));
  return installations;
}

class Machine {
  final int id, slots, capacity;

  Machine(this.id, this.slots, this.capacity);

  String toString() => 'Machine[id:$id slots:$slots capacity:$capacity]';
}

final UNAVAILABLE = new Machine(null, 1, null);

class Group {
  final int id;

  Group(this.id);

  String toString() => 'Group[id:$id]';
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
      var ok = true;
      for (; i < pos + m.slots; i++) {
        if (i >= slotsByRow) {
          ok = false;
          break;
        }
        final other = slots[row][i];
        if (other != null) {
          i += other.slots - 1;
          ok = false;
          break;
        }
      }
      if (ok) {
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
    return result..sort((i1, i2) => i1.machine.id.compareTo(i2.machine.id));
  }

  String toString() => 'DataCenter[$slots]';
}

class Installation {
  Machine machine;
  Group group;
  int row, slot;
  Installation(this.machine, this.group, this.row, this.slot);
  String toString() =>
      'Installation[machine:[$machine] row:$row slot:$slot group:$group]';
}
