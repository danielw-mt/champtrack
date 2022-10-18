import '../constants/game_actions.dart';

/// converts the action tag to the correct string specified in the strings
String realActionTag(String actionTag) {
  Map<String, String> allActionsMapping = actionMapping["allActions"]!;
  String actionTagKey = allActionsMapping.keys.firstWhere((key) => allActionsMapping[key] == actionTag, orElse: () => actionTag);
  return actionTagKey;
}
