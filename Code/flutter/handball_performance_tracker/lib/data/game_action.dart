import 'package:cloud_firestore/cloud_firestore.dart';

class GameAction {
  String? id;
  final String teamId;
  final String gameId;
  String playerId;
  String tag;
  String actionType;
  List<String> throwLocation;
  int timestamp;
  int relativeTime;

  GameAction(
      {this.id,
      this.teamId = "",
      this.gameId = "",
      this.playerId = "",
      this.tag = "",
      this.actionType = "",
      this.throwLocation = const [],
      this.timestamp = 0,
      this.relativeTime = 0});

  // @return Map<String,dynamic> as representation of GameAction object that can be saved to firestore
  Map<String, dynamic> toMap() {
    return {
      'teamId': teamId,
      'gameId': gameId,
      'playerId': playerId,
      'tag': tag,
      'actionType': actionType,
      'throwLocation': throwLocation,
      'timestamp': timestamp,
      'relativeTime': relativeTime
    };
  }

  // @return GameAction object according to GameAction data fetched from firestore
  factory GameAction.fromDocumentSnapshot(DocumentSnapshot doc) {
    final newAction = GameAction.fromMap(doc.data() as Map<String, dynamic>);
    newAction.id = doc.reference.id;
    return newAction;
  }

  // @return GameAction object created from map representation of GameAction
  factory GameAction.fromMap(Map<String, dynamic> map) {
    return GameAction(
        teamId: map['teamId'],
        gameId: map['gameId'],
        playerId: map['playerId'],
        tag: map['type'],
        actionType: map['actionType'],
        throwLocation: map['throwLocation'].cast<String>(),
        timestamp: map['timestamp'],
        relativeTime: map['relativeTime']);
  }

  // @return a new GameAction instance with the exact same properties as @param action
  GameAction.clone(GameAction action)
      : this(
            actionType: action.actionType,
            teamId: action.teamId,
            gameId: action.gameId,
            playerId: action.playerId,
            relativeTime: action.relativeTime,
            throwLocation: action.throwLocation,
            timestamp: action.timestamp,
            tag: action.tag);
}
