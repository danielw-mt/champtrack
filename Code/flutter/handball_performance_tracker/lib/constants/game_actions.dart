import 'package:handball_performance_tracker/constants/stringsGameScreen.dart';
import 'package:handball_performance_tracker/constants/stringsGeneral.dart';

// action context
const String actionContextAttack = "attack";
const String actionContextDefense = "defense";
const String actionContextSevenMeter_meter = "seven_meter";
const String actionContextGoalkeeper = "goalkeeper";
const String actionContextOtherGoalkeeper = "otherGoalkeeper";
const String actionContextAllActions = "allActions";

// action tags
// TODO check if all these tags are actually used (e.g. <9 and >9) and so on
const String goalTag = "goal";
const String goalPosTag = "goal_pos";
const String goalSubNineTag = "goal<9m";
const String goalExtNineTag = "goal>9m";
const String goalChrunchtimeTag = "goal_crunchtime";
const String assistTag = "assist";
const String oneVOneTag = "1v1";
const String blockTag = "block";
const String blockAndStealTag = "block_steal";
const String forceTwoMinTag = "2min";
const String missTag = "miss";
const String missPosTag = "miss_pos";
const String missSubNineTag = "miss<9m";
const String missExtNineTag = "miss>9m";
const String missCrunchtimeTag = "miss_crunchtime";
const String trfTag = "trf";
const String foulSevenMeterTag = "foul";
const String timePenaltyTag = "time_pen";
const String redCardTag = "red";
const String paradeTag = "parade";
const String yellowCardTag = "yellow";
const String badPassTag = "bad_pass";
const String goalOpponentTag = "goal_opponent";
const String emptyGoalTag = "empty_goal";

const String positiveActionTag = "pos";
const String negativeActionTag = "neg";

const String goal7mTag = "goal7m";
const String missed7mTag = "missed7m";
const String parade7mTag = "parade7m";

Map<String, Map<String, String>> actionMapping = {
  actionContextAttack: {
    StringsGameScreen.lRedCard: redCardTag,
    StringsGameScreen.lYellowCard: yellowCardTag,
    StringsGameScreen.lTimePenalty: timePenaltyTag,
    StringsGameScreen.lGoal: goalTag,
    StringsGameScreen.lOneVsOneAnd7m: oneVOneTag,
    StringsGameScreen.lTwoMin: forceTwoMinTag,
    StringsGameScreen.lErrThrow: missTag,
    StringsGameScreen.lTrf: trfTag,
  },
  actionContextDefense: {
    StringsGameScreen.lRedCard: redCardTag,
    StringsGameScreen.lYellowCard: yellowCardTag,
    StringsGameScreen.lFoul7m: foulSevenMeterTag,
    StringsGameScreen.lTimePenalty: timePenaltyTag,
    StringsGameScreen.lBlockNoBall: blockTag,
    StringsGameScreen.lBlockAndSteal: blockAndStealTag,
    StringsGameScreen.lTrf: trfTag,
    StringsGameScreen.lTwoMin: forceTwoMinTag,
  },
  actionContextGoalkeeper: {
    StringsGameScreen.lRedCard: redCardTag,
    StringsGameScreen.lYellowCard: yellowCardTag,
    StringsGameScreen.lTimePenalty: timePenaltyTag,
    StringsGameScreen.lEmptyGoal: emptyGoalTag,
    StringsGameScreen.lErrThrowGoalkeeper: missTag,
    StringsGameScreen.lGoalGoalkeeper: goalTag,
    StringsGameScreen.lBadPass: badPassTag,
    StringsGameScreen.lParade: paradeTag,
    StringsGameScreen.lGoalOpponent: goalOpponentTag,
  },
  actionContextSevenMeter_meter: {
    StringsGameScreen.lGoal: goal7mTag,
    StringsGameScreen.lErrThrow: missed7mTag,
    StringsGameScreen.lGoalOpponent: goalOpponentTag,
    StringsGeneral.lCaught: parade7mTag
  },
  actionContextAllActions: {
    StringsGameScreen.lRedCard: redCardTag,
    StringsGameScreen.lYellowCard: yellowCardTag,
    StringsGameScreen.lTimePenalty: timePenaltyTag,
    StringsGameScreen.lGoal: goalTag,
    StringsGameScreen.lOneVsOneAnd7m: oneVOneTag,
    StringsGameScreen.lTwoMin: forceTwoMinTag,
    StringsGameScreen.lErrThrow: missTag,
    StringsGameScreen.lTrf: trfTag,
    StringsGameScreen.lFoul7m: foulSevenMeterTag,
    StringsGameScreen.lBlockNoBall: blockTag,
    StringsGameScreen.lBlockAndSteal: blockAndStealTag,
    StringsGameScreen.lParade: paradeTag,
    StringsGameScreen.lBadPass: badPassTag,
    StringsGameScreen.lGoalOpponent: goalOpponentTag,
    StringsGameScreen.lEmptyGoal: emptyGoalTag,
    StringsGameScreen.lGoalGoalkeeper: goalTag,
    StringsGeneral.lCaught: parade7mTag,
    StringsGameScreen.lErrThrowGoalkeeper: missTag,
  }
};

const Map<String, Map<String, int>> efScoreParameters = {
  positiveActionTag: {
    goalPosTag: 5,
    goalSubNineTag: 4,
    goalExtNineTag: 5,
    goalChrunchtimeTag: 9,
    assistTag: 6,
    oneVOneTag: 6,
    blockTag: 2,
    blockAndStealTag: 7,
    forceTwoMinTag: 8
  },
  negativeActionTag: {
    missPosTag: 6,
    missSubNineTag: 8,
    missExtNineTag: 5,
    missCrunchtimeTag: 10,
    trfTag: 8,
    foulSevenMeterTag: 7,
    timePenaltyTag: 8,
    redCardTag: 15
  }
};

int lastFiveMinThreshold = 3300;
