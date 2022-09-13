import 'package:flutter/material.dart';
import 'package:qrcode_tracing/auth/login_page.dart';
import 'package:qrcode_tracing/view/home_page.dart';
import 'package:qrcode_tracing/view/profile_page.dart';
import 'package:qrcode_tracing/widgets/text_widget.dart';
import 'package:get_storage/get_storage.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Drawer(
        child: ListView(
          padding: const EdgeInsets.only(top: 0),
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.teal,
              ),
              accountEmail: TextWidget(
                  text: box.read('contactNumber'),
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
              accountName: TextWidget(
                  text: box.read('name'),
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              currentAccountPicture: CircleAvatar(
                minRadius: 50,
                maxRadius: 50,
                backgroundImage: NetworkImage(box.read('profilePicture') ??
                    'https://cdn-icons-png.flaticon.com/512/149/149071.png'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: TextWidget(
                  text: 'Profile',
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: TextWidget(
                  text: 'Home',
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: TextWidget(
                  text: 'Logout',
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500),
              onTap: () {
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
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text(
                                'Close',
                                style: TextStyle(
                                    fontFamily: 'QRegular',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            FlatButton(
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
            ),
          ],
        ),
      ),
    );
  }
}
