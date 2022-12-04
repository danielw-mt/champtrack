import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/data/entities/game_action_entity.dart';

class GameAction {
  String? id;
  String path;
  String playerId;
  String context;
  String tag;
  List<String> throwLocation;
  int timestamp;

  GameAction({
    this.id,
    this.path = "",
    this.playerId = "",
    this.context = "",
    this.tag = "",
    this.throwLocation = const [],
    this.timestamp = 0,
  });

  // @return a new GameAction instance with the exact same properties as @param action
  GameAction.clone(GameAction action)
      : this(tag: action.tag, playerId: action.playerId, throwLocation: action.throwLocation, timestamp: action.timestamp, context: action.context);

  @override
  String toString() {
    return 'GameAction: { id: $id, +\n playerId: $playerId, +\n context: $context, +\n tag: $tag, +\n throwLocation: $throwLocation, +\n timestamp: $timestamp }';
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is GameAction && runtimeType == other.runtimeType && id == other.id;

  GameActionEntity toEntity() {
    DocumentReference actionReference = FirebaseFirestore.instance.doc(path);
    return GameActionEntity(
      documentReference: actionReference,
      playerId: playerId,
      context: context,
      tag: tag,
      throwLocation: throwLocation,
      timestamp: timestamp,
    );
  }

  GameAction fromEntity(GameActionEntity entity) {
    return GameAction(
      id: entity.documentReference!.id,
      path: entity.documentReference!.path,
      playerId: entity.playerId,
      context: entity.context,
      tag: entity.tag,
      throwLocation: entity.throwLocation,
      timestamp: entity.timestamp,
    );
  }
}


// @return Map<String,dynamic> as representation of GameAction object that can be saved to firestore
  // Map<String, dynamic> toMap() {
  //   return {

  //     'path': path,
  //     'playerId': playerId,
  //     'context': context,
  //     'tag': tag,
  //     'throwLocation': throwLocation,
  //     'timestamp': timestamp,
  //   };
  // }

  // @return GameAction object according to GameAction data fetched from firestore
  // factory GameAction.fromDocumentSnapshot(DocumentSnapshot doc) {
  //   final newAction = GameAction.fromMap(doc.data() as Map<String, dynamic>);
  //   newAction.id = doc.reference.id;
  //   return newAction;
  // }

  // // @return GameAction object created from map representation of GameAction
  // factory GameAction.fromMap(Map<String, dynamic> map) {
  //   return GameAction(
  //       playerId: map['playerId'],
  //       context: map['context'],
  //       tag: map['tag'],
  //       throwLocation: map['throwLocation'].cast<String>(),
  //       timestamp: map['timestamp'],);
  // }