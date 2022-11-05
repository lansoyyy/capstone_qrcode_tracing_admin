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
    String destination,
    String stopPlace) async {
  final docUser = FirebaseFirestore.instance.collection('Livestock').doc();

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
    'id': docUser.id,
    'stopPlace': stopPlace,
  };

  await docUser.set(json);
}
