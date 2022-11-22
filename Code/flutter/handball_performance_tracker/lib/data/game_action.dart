import 'package:cloud_firestore/cloud_firestore.dart';

class GameAction {
  String? id;
  final String teamId;
  final String gameId;
  String playerId;
  String context;
  String tag;
  List<String> throwLocation;
  List<int> actionCoordinates;
  int timestamp;
  int relativeTime;

  GameAction(
      {this.id,
      this.teamId = "",
      this.gameId = "",
      this.playerId = "",
      this.context = "",
      this.tag = "",
      this.throwLocation = const [],
      this.actionCoordinates = const [],
      this.timestamp = 0,
      this.relativeTime = 0});

  // @return Map<String,dynamic> as representation of GameAction object that can be saved to firestore
  Map<String, dynamic> toMap() {
    return {
      'teamId': teamId,
      'gameId': gameId,
      'playerId': playerId,
      'context': context,
      'tag': tag,
      'throwLocation': throwLocation,
      'actionCoordinates': actionCoordinates,
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
        context: map['context'],
        tag: map['tag'],
        throwLocation: map['throwLocation'].cast<String>(),
        actionCoordinates: map['actionCoordinates'].cast<int>(),
        timestamp: map['timestamp'],
        relativeTime: map['relativeTime']);
  }

  // @return a new GameAction instance with the exact same properties as @param action
  GameAction.clone(GameAction action)
      : this(
            tag: action.tag,
            teamId: action.teamId,
            gameId: action.gameId,
            playerId: action.playerId,
            relativeTime: action.relativeTime,
            throwLocation: action.throwLocation,
            actionCoordinates: action.actionCoordinates,
            timestamp: action.timestamp,
            context: action.context);
}
