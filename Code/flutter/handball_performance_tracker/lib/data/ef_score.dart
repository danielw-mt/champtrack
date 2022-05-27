class EfScore {
  double score;
  Map<String, int> actions;

  EfScore()
      : score = 0,
        actions = {};

  double calculate() {
    // TODO implement formula
    if (actions.isNotEmpty) {
      return 1;
    }
    return 0;
  }
}

class LiveEfScore extends EfScore {
  void addAction(String name) {
    print("adding action");
    if (actions.containsKey(name)) {
      actions[name] = actions[name]! + 1;
    } else {
      actions[name] = 1;
    }
    score = calculate();
  }

  void revertAction(String name) {
    print("reverting action");
    if (actions.containsKey(name) && (actions[name]! >= 1)) {
      actions[name] = actions[name]! - 1;
    } else {
      print("Trying to revert not existing action $name!");
    }
  }
}
