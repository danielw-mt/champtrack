// import 'package:cloud_firestore/cloud_firestore.dart';

// class Player {
//   // 1
//   final String? firstName;
//   final String? lastName;
//   final List<String>? positions;
//   String? referenceId;

//   Player({this.firstName, this.lastName, this.positions, this.referenceId})

  
//   Map<String, dynamic> _playerToJson(Player instance) => <String, dynamic>{
//       'firstName': instance.firstName,
//       'lastName': instance.lastName,
//       'positions': instance.positions,
//       //'vaccinations': _vaccinationList(instance.vaccinations),
//     };

//   }
//   // 5
//   // factory Player.fromSnapshot(DocumentSnapshot snapshot) {
//   //   final newPlayer = Player.fromJson(snapshot.data() as Map<String, dynamic>);
//   //   newPlayer.referenceId = snapshot.reference.id;
//   //   return newPlayer;
//   // } 
//   // 6
//   // factory Player.fromJson(Map<String, dynamic> json) => _playerFromJson(json);
//   // 7
//   Map<String, dynamic> toJson() => _playerToJson(this);

//   @override
//   String toString() => 'Player<$firstName>';


//   // Player _playerFromJson(Map<String, dynamic> json) {
//   // return Player(json['firstName'] as String,
//   //     json["lastName"] as String,
//   //     json["positions"] as List<String>,

//   // );   

// // 3
// // 4
