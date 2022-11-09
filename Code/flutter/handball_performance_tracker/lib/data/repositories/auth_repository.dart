import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/data/entities/entities.dart';

// Tutorial: https://dhruvnakum.xyz/flutter-bloc-v8-google-sign-in-and-firebase-authentication-2022-guide#heading-persisting-authentication-state

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  /// send e-mail and password to [createUserWithEmailAndPassword] method from [FirebaseAuth]
  ///
  /// throw error codes for weak password and email already in use
  Future<void> signUp({required String clubName, required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      // create the club with the now created user
      User? user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection("clubs").add({
        "name": clubName,
        "roles": {user!.uid: "admin"}
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Club> fetchLoggedInClub() async {
    QuerySnapshot clubSnapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .where("roles.${FirebaseAuth.instance.currentUser!.uid}", isEqualTo: "admin")
        .limit(1)
        .get();
    return clubSnapshot.docs.map((doc) => Club.fromEntity(ClubEntity.fromSnapshot(doc))).first;
  }

  // TODO implement like here: https://dhruvnakum.xyz/flutter-bloc-v8-google-sign-in-and-firebase-authentication-2022-guide#heading-folder-structure
  // Future<void> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //     final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken,
  //       idToken: googleAuth?.idToken,
  //     );

  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }

}
