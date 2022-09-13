import 'package:cloud_firestore/cloud_firestore.dart';

Future addLivestock(
    String name,
    String contactNumber,
    String address,
    String profilePicture,
    String livestockPicture,
    String type,
    String weight,
    String breed,
    String origin,
    String destination) async {
  final docUser = FirebaseFirestore.instance
      .collection('Livestock')
      .doc(name + contactNumber + type + breed + destination);

  final json = {
    'name': name,
    'contactNumber': contactNumber,
    'address': address,
    'profilePicture': profilePicture,
    'livestockPicture': livestockPicture,
    'type': type,
    'weight': weight,
    'breed': breed,
    'origin': origin,
    'destination': destination,
  };

  await docUser.set(json);
}
