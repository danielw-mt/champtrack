import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/data/entities/entities.dart';
import 'package:logger/logger.dart';
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

/// Defines methods that need to be implemented by data providers. Could also be something other than Firebase
abstract class ClubRepository {
  // reading the club
  //Stream<Club> clubs();
  Future<Club> fetchClub();

  // if user wants to delete all his data
  Future<void> deleteClub(Club club);

  // if user wants to update his club - for example its name
  Future<void> updateClub(Club club);
}

/// Implementation of ClubRepository that uses Firebase as the data provider
class ClubFirebaseRepository extends ClubRepository {
  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  Query loggedInClubQuery = FirebaseFirestore.instance.collection('clubs').where("roles.${FirebaseAuth.instance.currentUser!.uid}", isEqualTo: "admin").limit(1);

  // get the club that the user is currently logged in with
  Future<Club> fetchClub() async {
    var snapshot = await loggedInClubQuery.get();
    return snapshot.docs.map((doc) => Club.fromEntity(ClubEntity.fromSnapshot(doc))).first;
  }

  // Delete the club in the query. There should only be one club in the query belonging to the logged in user
  @override
  Future<void> deleteClub(Club club) async {
    QuerySnapshot querySnapshot = await loggedInClubQuery.get();
    querySnapshot.docs.forEach((doc) async {
      await doc.reference.delete();
    });
  }

  // Update the club in the query. There should only be one club in the query belonging to the logged in user
  @override
  Future<void> updateClub(Club club) async {
    QuerySnapshot querySnapshot = await loggedInClubQuery.get();
    querySnapshot.docs.forEach((doc) async {
      await doc.reference.update(club.toEntity().toDocument());
    });
  }
}
