import 'package:handball_performance_tracker/strings.dart';

const String attack = "attack";
const String defense = "defense";

const Map<String, Map<String, String>> actionMapping = {
  attack: {
    Strings.lRedCard: "red",
    Strings.lYellowCard: "yellow",
    Strings.lTimePenalty: "penalty",
    Strings.lGoal: "goal",
    Strings.lOneVsOneAnd7m: "1v1",
    Strings.lTwoMin: "2min",
    Strings.lErrThrow: "err",
    Strings.lTrf: "trf",
  },
  defense: {
    Strings.lRedCard: "red",
    Strings.lYellowCard: "yellow",
    Strings.lFoul7m: "foul",
    Strings.lTimePenalty: "penalty",
    Strings.lBlockNoBall: "block",
    Strings.lBlockAndSteal: "block_st",
    Strings.lTrf: "trf",
  }
};

const String goal = "goal";
const String goalPos = "goal_pos";
const String goalUnderNine = "goal<9m";
const String goalOutsideNine = "goal>9m";
const String goalLastFive = "goalLastFive";
const String assist = "assist";
const String oneVsOne = "1v1";
const String blockNoBall = "block";
const String blockAndSteal = "block_steal";
const String twoMin = "2min";
const String errThrow = "err";
const String errThrowPos = "err_pos";
const String errThrowUnderNine = "err<9m";
const String errThrowOutsideNine = "err>9m";
const String errThrowLastFive = "errLastFive";
const String trf = "trf";
const String foulWithSeven = "foul";
const String timePenalty = "timePen";
const String redCard = "red";

const String positiveAction = "pos";
const String negativeAction = "neg";

const Map<String, Map<String, int>> efScoreParameters = {
  "pos": {
    "goal_pos": 5,
    "goal<9m": 4,
    "goal>9m": 5,
    "goalLastFive": 9,
    "assist": 7,
    "1v1": 7,
    "block": 3,
    "block_steal": 8,
    "2min": 9
  },
  "neg": {
    "err_pos": 6,
    "err<9m": 8,
    "err>9m": 6,
    "errLastFive": 10,
    "trf": 8,
    "foul": 7,
    "timePen": 8,
    "red": 15
  }
};

int lastFiveMinThreshold = 3300;
