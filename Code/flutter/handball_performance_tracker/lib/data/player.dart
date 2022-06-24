import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/data/game_action.dart';
import 'ef_score.dart';

class Player {
  String? id;
  String firstName;
  String lastName;
  String nickName;
  int number;
  List<String> positions;
  List<String> games;
  DocumentReference? clubId;
  DocumentReference? teamId;
  LiveEfScore efScore;

  Player(
      {this.id = "",
      this.firstName = "",
      this.lastName = "",
      this.nickName = "",
      this.number = 0,
      this.positions = const [""],
      this.clubId = null,
      this.teamId = null,
      this.games = const [""]})
      : efScore = LiveEfScore();

  // @return Map<String,dynamic> as representation of Player object that can be saved to firestore
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'nickName': nickName,
      'number': number,
      'positions': positions,
      'clubId': clubId,
      'teamId': teamId,
      'games': games
    };
  }

  // @return Player object according to Player data fetched from firestore
  factory Player.fromDocumentSnapshot(DocumentSnapshot doc) {
    final newPlayer =
        Player.fromMap(Map.from(doc.data() as Map<String, dynamic>));
    newPlayer.id = doc.reference.id;
    return newPlayer;
  }

  // @return Player object created from map representation of Player
  factory Player.fromMap(Map<String, dynamic> map) {
    String firstName = map["firstName"];
    print("firstName worked");
    String lastName = map["lastName"];
    print("lastname worked");
    String nickName = map["nickName"];
    print("nickname worked");
    int number = map["number"];
    print("number worked");
    List<String> positions = map["positions"].cast<String>();
    print("positions worked");
    DocumentReference clubId = map["clubId"];
    print("clubid worked");
    DocumentReference teamId = map["teamId"];
    print("teamid worked");
    List<String> games = map["games"].cast<String>();
    print("games worked");
    return Player(
        firstName: firstName,
        lastName: lastName,
        nickName: nickName,
        number: number,
        positions: positions,
        clubId: clubId,
        teamId: teamId,
        games: games);
  }

  // Players are considered as identical if they have the same id
  @override
  bool operator ==(dynamic other) =>
      other != null && other is Player && id == other.id;

  void addAction(GameAction action) => efScore.addAction(action, positions);

  @override
  String toString() {
    return "Player( +\n firstName: ${firstName}, +\n lastName: ${lastName}, +\n nickName: ${nickName} ";
  }
}
