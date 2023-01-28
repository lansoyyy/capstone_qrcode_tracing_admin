import 'package:flutter/material.dart';
import 'package:qrcode_tracing/widgets/drawer_widget.dart';
import 'package:qrcode_tracing/widgets/text_widget.dart';
import 'package:get_storage/get_storage.dart';

import '../auth/login_page.dart';

class ProfilePage extends StatelessWidget {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: TextWidget(
            text: 'PROFILE',
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text(
                            'Logout Confirmation',
                            style: TextStyle(
                                fontFamily: 'QBold',
                                fontWeight: FontWeight.bold),
                          ),
                          content: const Text(
                            'Are you sure you want to Logout?',
                            style: TextStyle(fontFamily: 'QRegular'),
                          ),
                          actions: <Widget>[
                            MaterialButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text(
                                'Close',
                                style: TextStyle(
                                    fontFamily: 'QRegular',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => LogInPage()));
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
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            CircleAvatar(
              minRadius: 70,
              maxRadius: 70,
              backgroundImage: NetworkImage(
                box.read('profilePicture') ??
                    'https://cdn-icons-png.flaticon.com/512/149/149071.png',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: ListTile(
                title: TextWidget(
                    text: box.read('name'),
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                subtitle: TextWidget(
                    text: 'Name',
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w200),
                trailing: const Icon(Icons.person),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 50, right: 50, top: 10, bottom: 10),
              child: ListTile(
                title: TextWidget(
                    text: box.read('contactNumber'),
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                subtitle: TextWidget(
                    text: 'Contact Number',
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w200),
                trailing: const Icon(Icons.phone),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: ListTile(
                title: TextWidget(
                    text: box.read('address'),
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                subtitle: TextWidget(
                    text: 'Address',
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w200),
                trailing: const Icon(Icons.location_on_rounded),
              ),
            )
          ],
        ),
      ),
    );
  }
}
