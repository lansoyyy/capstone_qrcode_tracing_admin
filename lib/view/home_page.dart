import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qrcode_tracing/services/cloud_function/add_livestock.dart';
import 'package:qrcode_tracing/view/generate_qrcode_page.dart';
import 'package:qrcode_tracing/widgets/button_widget.dart';
import 'package:qrcode_tracing/widgets/drawer_widget.dart';
import 'package:qrcode_tracing/widgets/text_widget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String type = '';

  late String weight = '';

  late String breed = '';

  late String origin = '';

  late String destination = '';

  final box = GetStorage();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  late String fileName = '';

  late File imageFile;

  late String imageURL = '';

  var hasLoaded = false;

  Future<void> uploadPicture(String inputSource) async {
    final picker = ImagePicker();
    XFile pickedImage;
    try {
      pickedImage = (await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920))!;

      fileName = path.basename(pickedImage.path);
      imageFile = File(pickedImage.path);

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: AlertDialog(
                title: Row(
              children: const [
                CircularProgressIndicator(
                  color: Colors.black,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Loading . . .',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QRegular'),
                ),
              ],
            )),
          ),
        );

        await firebase_storage.FirebaseStorage.instance
            .ref('Livestock/$fileName')
            .putFile(imageFile);
        imageURL = await firebase_storage.FirebaseStorage.instance
            .ref('Livestock/$fileName')
            .getDownloadURL();

        setState(() {
          hasLoaded = true;
        });

        Navigator.of(context).pop();
      } on firebase_storage.FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.grey[100],
          drawer: const MyDrawer(),
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  showAboutDialog(
                      context: context,
                      applicationName: 'QRCode',
                      applicationIcon:
                          Image.asset('assets/images/logoonly.png', height: 50),
                      applicationLegalese: "QR Code based Livestock Tracing",
                      applicationVersion: 'v1.0');
                },
                icon: const Icon(Icons.info),
              ),
            ],
            centerTitle: true,
            backgroundColor: Colors.teal,
            title: const Text(
              'HOME',
              style: TextStyle(
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'QRegular'),
            ),
            bottom: TabBar(indicatorColor: Colors.white, tabs: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    const Icon(
                      Icons.list_alt_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextWidget(
                        text: 'Livestocks',
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    const Icon(
                      Icons.post_add,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextWidget(
                        text: 'Post',
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ],
                ),
              )
            ]),
          ),
          body: TabBarView(children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Livestock')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    print('error');
                    return const Center(child: Text('Error'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print('waiting');
                    return const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.black,
                      )),
                    );
                  }

                  final data = snapshot.requireData;
                  return GridView.builder(
                      itemCount: snapshot.data?.size ?? 0,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: ((context, index) {
                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              decoration: const BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5))),
                              height: 100,
                              width: 150,
                              child: Image.network(
                                data.docs[index]['livestockPicture'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5))),
                              height: 50,
                              width: 150,
                              child: Center(
                                child: TextWidget(
                                    text: data.docs[index]['type'],
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        );
                      }));
                }),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Post Livestock',
                      style: TextStyle(
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 24,
                          fontFamily: 'QRegular'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    hasLoaded == true
                        ? Container(
                            height: 130,
                            width: 280,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.network(imageURL, fit: BoxFit.cover),
                          )
                        : GestureDetector(
                            onTap: () {
                              uploadPicture('gallery');
                            },
                            child: Container(
                              height: 130,
                              width: 280,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 38,
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextWidget(
                        text: 'Livestock Image',
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w300),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                      child: TextFormField(
                        style: const TextStyle(
                            color: Colors.black, fontFamily: 'Quicksand'),
                        onChanged: (_input) {
                          type = _input;
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          labelText: 'Type of Livestock',
                          labelStyle: const TextStyle(
                            fontFamily: 'Quicksand',
                            color: Colors.black,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                      child: TextFormField(
                        maxLength: 3,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                            color: Colors.black, fontFamily: 'Quicksand'),
                        onChanged: (_input) {
                          weight = _input;
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          suffix: const Text('kg'),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          labelText: 'Weight of Livestock',
                          labelStyle: const TextStyle(
                            fontFamily: 'Quicksand',
                            color: Colors.black,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                      child: TextFormField(
                        style: const TextStyle(
                            color: Colors.black, fontFamily: 'Quicksand'),
                        onChanged: (_input) {
                          breed = _input;
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          labelText: 'Breed of Livestock',
                          labelStyle: const TextStyle(
                            fontFamily: 'Quicksand',
                            color: Colors.black,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                      child: TextFormField(
                        style: const TextStyle(
                            color: Colors.black, fontFamily: 'Quicksand'),
                        onChanged: (_input) {
                          origin = _input;
                        },
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.location_on_rounded),
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          labelText: 'Location of Origin',
                          labelStyle: const TextStyle(
                            fontFamily: 'Quicksand',
                            color: Colors.black,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                      child: TextFormField(
                        style: const TextStyle(
                            color: Colors.black, fontFamily: 'Quicksand'),
                        onChanged: (_input) {
                          destination = _input;
                        },
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.my_location),
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          labelText: 'Location of Destination',
                          labelStyle: const TextStyle(
                            fontFamily: 'Quicksand',
                            color: Colors.black,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ButtonWidget(
                        onPressed: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text(
                                      'Confirmation',
                                      style: TextStyle(
                                          fontFamily: 'QBold',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: const Text(
                                      'Livestock Posted Succesfully!',
                                      style: TextStyle(fontFamily: 'QRegular'),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          addLivestock(
                                              box.read('name'),
                                              box.read('contactNumber'),
                                              box.read('address'),
                                              box.read('profilePicture') ??
                                                  'https://cdn-icons-png.flaticon.com/512/149/149071.png',
                                              imageURL,
                                              type,
                                              weight,
                                              breed,
                                              origin,
                                              destination);
                                          box.write('type', type);
                                          box.write('breed', breed);
                                          box.write('destination', destination);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      QRCodePage()));
                                        },
                                        child: const Text(
                                          'Continue',
                                          style: TextStyle(
                                              fontFamily: 'QRegular',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ));
                        },
                        text: 'Post'),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ])),
    );
  }
}
