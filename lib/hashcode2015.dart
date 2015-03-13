// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The hashcode2015 library.
library hashcode2015;

String compute(String input) {
  return input;
}

List<Installation> optimize1(
    DataCenter dc, List<Machine> machines, List<Group> groups) {
  num f1(Machine m) => m.capacity / m.slots;
  num f2(Machine m) => m.capacity;
  num f3(Machine m) => m.slots;
  num f4(Machine m) => m.capacity * m.slots;
  num f5(Machine m) => m.slots / m.capacity;
  final fRow = f1;

  int groupId = 0;
  final machinesByGroups = new Map.fromIterable(groups, key: (g) => g.id, value: (_) => []);
  machines.sort((m1, m2) => fRow(m2).compareTo(fRow(m1)));
  for (final m in machines) {
    final indexes = dc.linesCharge().keys.toList().reversed.toList();
    for (int i = 0; i < dc.rows; i++) {
      final success = dc.putOnRow(indexes[i], m);
      if (success) {
        machinesByGroups[groupId++ % groups.length].add(m);
        break;
      }
    }
  }

  print(new Map.fromIterable(machinesByGroups.keys, value: (k) => machinesByGroups[k].length));

  // group allocations
  final installations = dc.installations;

  if (groups.isNotEmpty) {
    for (final installation in installations) {
      for (final groupId in machinesByGroups.keys) {
        if (machinesByGroups[groupId].contains(installation.machine)) {
          installation.group = groups.firstWhere((g) => g.id == groupId);
          break;
        }
      }
    }
  }

  installations.sort((i1, i2) => i1.machine.id.compareTo(i2.machine.id));
  return installations;
}

class Score {
  int total;
  Group group;
  Score(this.total, this.group);

  String toString() => 'Score[group:$group total:$total]';
}

class Machine {
  final int id, slots, capacity;

  Machine(this.id, this.slots, this.capacity);

  String toString() => 'Machine[id:$id slots:$slots capacity:$capacity]';
}

final UNAVAILABLE = new Machine(null, 1, 0);

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

  Map<int, int> linesCharge() {
    final result =
        new Map.fromIterable(new Iterable.generate(rows), value: (_) => 0);
    for (int i = 0; i < rows; i++) {
      result[i] =
          slots[i].where((m) => m != null).fold(0, (t, m) => t + m.capacity);
    }
    final orderedIndexes = result.keys.toList()
      ..sort((i1, i2) => result[i1].compareTo(result[i2]));
    return new Map.fromIterable(orderedIndexes, value: (i) => result[i]);
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
