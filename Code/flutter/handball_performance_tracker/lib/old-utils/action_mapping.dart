import '../old-constants/game_actions.dart';

/// converts the action tag to the correct string specified in the strings
String realActionTag(String actionTag) {
  Map<String, String> allActionsMapping = actionMapping["allActions"]!;
  // if there is a strings set for the action tag return that string otherwise return the actiontag
  String actionTagKey = allActionsMapping.keys.firstWhere((key) => allActionsMapping[key] == actionTag, orElse: () => actionTag);
  return actionTagKey;
}
