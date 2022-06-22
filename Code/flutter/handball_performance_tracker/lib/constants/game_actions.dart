import 'package:handball_performance_tracker/strings.dart';

const String attack = "attack";
const String defense = "defense";

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
const String yellowCard = "yellow";

const String positiveAction = "pos";
const String negativeAction = "neg";

Map<String, Map<String, String>> actionMapping = {
  attack: {
    Strings.lRedCard: redCard,
    Strings.lYellowCard: yellowCard,
    Strings.lTimePenalty: timePenalty,
    Strings.lGoal: goal,
    Strings.lOneVsOneAnd7m: oneVsOne,
    Strings.lTwoMin: twoMin,
    Strings.lErrThrow: errThrow,
    Strings.lTrf: trf,
  },
  defense: {
    Strings.lRedCard: redCard,
    Strings.lYellowCard: yellowCard,
    Strings.lFoul7m: foulWithSeven,
    Strings.lTimePenalty: timePenalty,
    Strings.lBlockNoBall: blockNoBall,
    Strings.lBlockAndSteal: blockAndSteal,
    Strings.lTrf: trf,
  }
};

const Map<String, Map<String, int>> efScoreParameters = {
  positiveAction: {
    goalPos: 5,
    goalUnderNine: 4,
    goalOutsideNine: 5,
    goalLastFive: 9,
    assist: 7,
    oneVsOne: 7,
    blockNoBall: 3,
    blockAndSteal: 8,
    twoMin: 9
  },
  negativeAction: {
    errThrowPos: 6,
    errThrowUnderNine: 8,
    errThrowOutsideNine: 6,
    errThrowLastFive: 10,
    trf: 8,
    foulWithSeven: 7,
    timePenalty: 8,
    redCard: 15
  }
};

int lastFiveMinThreshold = 3300;
