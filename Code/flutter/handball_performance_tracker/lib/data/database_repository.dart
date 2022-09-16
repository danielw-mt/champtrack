import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:handball_performance_tracker/data/game.dart';
import 'package:handball_performance_tracker/data/team.dart';
import 'package:handball_performance_tracker/data/game_action.dart';
import 'package:handball_performance_tracker/data/player.dart';
import 'package:handball_performance_tracker/data/club.dart';
import 'package:logger/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
      ),
);

class DatabaseRepository {
  // is set once initializeLoggedInClub is being called
  late DocumentReference<Map<String, dynamic>> _loggedInClubReference;

  // way of specifying what db to use. Can be used to switch between dev and prod db
  // final FirebaseFirestore _db = FirebaseFirestore.instanceFor(app: Firebase.app('dev'));

  // @return Club object according to Club data fetched from firestore where the user id is in the roles map
  Future<Club> initializeLoggedInClub() async {
    logger.d("initializing logged in club");
    // get uuid of logged in user
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      logger.e("User is null");
    }
    // get reference to club where the user is admin. There should only be one club where this is the case
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("clubs")
        .where("roles.${user!.uid}", isEqualTo: "admin")
        .get();
    // there should only be one club that corresponds to a user
    if (querySnapshot.docs.length == 1) {
      print("club found");
      // store a reference to the logged in Club so all other methods can reference its children documents
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      _loggedInClubReference = documentSnapshot.reference
          as DocumentReference<Map<String, dynamic>>;
      return Club.fromDocumentSnapshot(documentSnapshot);
    }
    if (querySnapshot.docs.length == 0) {
      throw new Exception("logged in user is associated with no club");
    } else {
      throw new Exception(
          "logged in user is associated with more than one club");
    }
  }

  // TODO remove this as it is saved in the Club
  // Future<DocumentReference> getClubReference(Club club) async {
  //   return await _db.collection("clubs").doc(club.id);
  // }

  Future<DocumentSnapshot> getPlayer(String playerId) async {
    return await _loggedInClubReference
        .collection("players")
        .doc(playerId)
        .get();
  }

  /// delete player from players collection and all the teams he belongs to
  Future<void> deletePlayer(Player player) async {
    // delete player from player collection
    await _loggedInClubReference.collection("players").doc(player.id).delete();
    // delete player reference from selected team player references
    List<String> teamReferenceStrings = player.teams;
    // delete player from each team
    teamReferenceStrings.forEach((String teamReferenceString) async {
      DocumentReference<Map<String, dynamic>> relevantTeam =
          _loggedInClubReference; //.doc(teamReferenceString);

      // get a list of player references from the document
      DocumentSnapshot snapshot = await relevantTeam.get();
      Map<String, dynamic> snapshotData =
          snapshot.data() as Map<String, dynamic>;
      List<DocumentReference> playerReferences =
          snapshotData["players"].cast<DocumentReference>();

      //get a reference of the player object from the players collection
      DocumentReference<Map<String, dynamic>> relevantPlayer =
          _loggedInClubReference.collection("players").doc(player.id);
      playerReferences.remove(relevantPlayer);
      await relevantTeam.update({'players': playerReferences});
      // if onFieldPlayer contains player remove him from onFieldplayer list as well
      List<DocumentReference> onFieldPlayerReferences =
          snapshotData["onFieldPlayers"].cast<DocumentReference>();
      // only update onFieldPlayers if it is really necessary
      bool onFieldPlayersNeedToBeUpdated = false;
      onFieldPlayerReferences.forEach((DocumentReference reference) {
        if (reference.id == player.id) {
          onFieldPlayerReferences.remove(reference);
          onFieldPlayersNeedToBeUpdated = true;
        }
      });
      if (onFieldPlayersNeedToBeUpdated) {
        await relevantTeam.update({'onFieldPlayer': onFieldPlayerReferences});
      }
    });
  }

  /// @return asynchronous reference to Player object that was saved to firebase
  /// add player to players collection in firebase
  Future<DocumentReference> addPlayer(Player player) {
    return _loggedInClubReference.collection("players").add(player.toMap());
  }

  /// update a Player's firestore record according to @param player properties
  void updatePlayer(Player player) async {
    await _loggedInClubReference
        .collection("players")
        .doc(player.id)
        .update(player.toMap());
  }

  /// add player to a team in firebase with teamReference string i.e. teams/ypunI6UsJmTr2LxKh1aw
  void addPlayerToTeam(Player player, Team relevantTeam) async {
    print("trying to add player ${player.id} to team ${relevantTeam.id}");
    relevantTeam.players.add(player);
    DocumentReference<Map<String, dynamic>> selectedTeam =
        _loggedInClubReference.collection("teams").doc(relevantTeam.id);
    // get a list of player references from the document
    DocumentSnapshot snapshot = await selectedTeam.get();
    Map<String, dynamic> snapshotData = snapshot.data() as Map<String, dynamic>;
    List<DocumentReference> playerReferences =
        snapshotData["players"].cast<DocumentReference>();
    //get a reference of the player object from the players collection
    DocumentReference<Map<String, dynamic>> relevantPlayer =
        _loggedInClubReference.collection("players").doc(player.id);

    // add player to reference list
    playerReferences.add(relevantPlayer);
    // update the list of references in the respective team
    await selectedTeam.update({'players': playerReferences});
  }

  /// update all onFieldPlayers to the ones that are selected in the @param team
  void updateOnFieldPlayers(List<Player> onFieldPlayers, Team team) {
    List<DocumentReference> onFieldPlayerReferences = [];
    onFieldPlayers.forEach((Player player) {
      DocumentReference<Map<String, dynamic>> playerReference =
          _loggedInClubReference.collection("players").doc(player.id);
      onFieldPlayerReferences.add(playerReference);
    });
    _loggedInClubReference
        .collection("teams")
        .doc(team.id)
        .update({'onFieldPlayers': onFieldPlayerReferences});
  }

  /// @return asynchronous reference to Game object that was saved to firebase
  Future<DocumentReference> addGame(Game game) async {
    // if we are offline this future will never complete and block our app
    // thus we need to differentiate between online and offline mode
    var result = await Connectivity().checkConnectivity();
    // if there is no internet create the reference id for the object manually
    if (result == ConnectivityResult.none) {
      // _db.collection("games").add(game.toMap());
      DocumentReference docRef =
          _loggedInClubReference.collection('games').doc();
      docRef.set(game.toMap()).then(
          (value) => print("Game Added on backend after coming back online"));
      return docRef;
    } else {
      return _loggedInClubReference.collection("games").add(game.toMap());
    }
  }

  /// update a Game's firestore record according to @param game properties
  void updateGame(Game game) async {
    print("updating game");
    await _loggedInClubReference
        .collection("games")
        .doc(game.id)
        .update(game.toMap());
  }

  // query all teams in db
  Stream<QuerySnapshot> getAllTeamsStream() {
    return _loggedInClubReference.collection("teams").snapshots();
  }

  Future<QuerySnapshot> getTeams() async {
    logger.d("getting all teams");
    return await _loggedInClubReference.collection("teams").get();
  }

  Future<QuerySnapshot> getAllPlayers() async {
    logger.d("getting all players");
    return await _loggedInClubReference.collection("players").get();
  }

  /// @return asynchronous reference to GameAction object that was saved to firebase
  Future<DocumentReference> addActionToGame(GameAction action) async {
    // if we are offline this future will never complete and block our app
    // thus we need to differentiate between online and offline mode
    var result = await Connectivity().checkConnectivity();
    // if there is no internet create the reference id for the object manually
    if (result == ConnectivityResult.none) {
      // _db.collection("games").add(game.toMap());
      DocumentReference docRef = _loggedInClubReference
          .collection('games')
          .doc(action.gameId)
          .collection("actions")
          .doc();
      docRef.set(action.toMap()).then(
          (value) => print("Game Added on backend after coming back online"));
      return docRef;
    } else {
      return _loggedInClubReference
          .collection("games")
          .doc(action.gameId)
          .collection("actions")
          .add(action.toMap());
    }
  }

  /// update a GameAction's firestore record according to @param action properties
  void updateAction(GameAction action) async {
    await _loggedInClubReference
        .collection("games")
        .doc(action.gameId)
        .collection("actions")
        .doc(action.id)
        .update(action.toMap());
  }

  /// delete a the firestore record of a given @param action
  void deleteAction(GameAction action) async {
    await _loggedInClubReference
        .collection("games")
        .doc(action.gameId)
        .collection("actions")
        .doc(action.id)
        .delete();
  }

  void deleteLastAction() async {
    // get the latest game
    QuerySnapshot mostRecentGameQuery = await _loggedInClubReference
        .collection("games")
        .orderBy("date", descending: true)
        .limit(1)
        .get();
    DocumentSnapshot mostRecentGame = mostRecentGameQuery.docs[0];
    // look inside gameActions for the lastest action for that game
    QuerySnapshot mostRecentActionQuery = await _loggedInClubReference
        .collection("games")
        .doc(mostRecentGame.id)
        .collection("actions")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .get();

    DocumentSnapshot mostRecentAction = mostRecentActionQuery.docs[0];
    // delete most recent doc
    _loggedInClubReference
        .collection("games")
        .doc(mostRecentGame.id)
        .collection("actions")
        .doc(mostRecentAction.id)
        .delete();
  }

  Future<List<GameAction>> getGameActionsFromGame(String gameId) async {
    QuerySnapshot querySnapshot = await _loggedInClubReference
        .collection("games")
        .doc(gameId)
        .collection("actions")
        .orderBy("timestamp", descending: true)
        .get();
    List<GameAction> gameActions = [];
    querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
      gameActions.add(
          GameAction.fromMap(documentSnapshot.data() as Map<String, dynamic>));
    });
    return gameActions;
  }

  /// @return true if there is a game sync within the last @param minutes
  Future<bool> isThereAGameWithinLastMinutes(int minutes) async {
    DateTime now = DateTime.now();
    DateTime then = now.subtract(Duration(minutes: minutes));
    QuerySnapshot snapshot = await _loggedInClubReference
        .collection("games")
        .where("lastSync", isGreaterThan: then.toIso8601String())
        .get();
    if (snapshot.docs.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  /// @return json data of the most recent game
  Future<Game> getMostRecentGame() async {
    QuerySnapshot snapshot = await _loggedInClubReference
        .collection("games")
        .orderBy("lastSync", descending: true)
        .limit(1)
        .get();
    DocumentSnapshot mostRecentGame = snapshot.docs[0];
    return Game.fromDocumentSnapshot(mostRecentGame);
  }

  Future<DocumentSnapshot> getTeam(String id) async {
    DocumentSnapshot snapshot =
        await _loggedInClubReference.collection("teams").doc(id).get();
    return snapshot;
  }
}
