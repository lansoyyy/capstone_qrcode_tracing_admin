import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

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
  final box = GetStorage();
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
    'id': docUser.id,
    'stopPlace': stopPlace,
    'username': box.read('username')
  };

  await docUser.set(json);
}
