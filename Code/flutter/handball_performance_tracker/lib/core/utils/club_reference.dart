import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

String clubReferencePath = "";
Future<DocumentReference> getClubReference() async {
  if (clubReferencePath == "") {
    QuerySnapshot clubSnapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .where("roles.${FirebaseAuth.instance.currentUser!.uid}", isEqualTo: "admin")
        .limit(1)
        .get();
    if (clubSnapshot.docs.length != 1) {
      throw Exception("No club found for user id. Cannot fetch players");
    }
    DocumentReference clubReference = clubSnapshot.docs[0].reference;
    clubReferencePath = clubReference.path;
    return clubReference;
  }
  return FirebaseFirestore.instance.doc(clubReferencePath);
}
