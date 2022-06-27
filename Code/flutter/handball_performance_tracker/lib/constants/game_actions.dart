import 'package:handball_performance_tracker/constants/stringsGameScreen.dart';
import 'package:handball_performance_tracker/constants/stringsGeneral.dart';

const String attack = "attack";
const String defense = "defense";
const String seven_meter = "seven_meter";
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
    StringsGameScreen.lRedCard: redCard,
    StringsGameScreen.lYellowCard: yellowCard,
    StringsGameScreen.lTimePenalty: timePenalty,
    StringsGameScreen.lGoal: goal,
    StringsGameScreen.lOneVsOneAnd7m: oneVsOne,
    StringsGameScreen.lTwoMin: twoMin,
    StringsGameScreen.lErrThrow: errThrow,
    StringsGameScreen.lTrf: trf,
  },
  defense: {
    StringsGameScreen.lRedCard: redCard,
    StringsGameScreen.lYellowCard: yellowCard,
    StringsGameScreen.lFoul7m: foulWithSeven,
    StringsGameScreen.lTimePenalty: timePenalty,
    StringsGameScreen.lBlockNoBall: blockNoBall,
    StringsGameScreen.lBlockAndSteal: blockAndSteal,
    StringsGameScreen.lTrf: trf,
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
