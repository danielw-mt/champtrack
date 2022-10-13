import '../constants/game_actions.dart';

/// converts the action tag to the correct string specified in the strings
  String realActionType(String actionType) {
    Map<String, String> allActionsMapping = actionMapping["allActions"]!;
    String actionTypeKey = allActionsMapping.keys.firstWhere((key) => allActionsMapping[key] == actionType, orElse: () => actionType);
    return actionTypeKey;
  }