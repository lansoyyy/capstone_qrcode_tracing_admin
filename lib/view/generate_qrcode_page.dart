import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode_tracing/view/home_page.dart';
import 'package:qrcode_tracing/widgets/button_widget.dart';
import 'package:qrcode_tracing/widgets/text_widget.dart';
import 'package:get_storage/get_storage.dart';

class QRCodePage extends StatelessWidget {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                  text: 'Screenshot QR Code',
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w300),
              const SizedBox(
                height: 50,
              ),
              QrImage(
                  data: box.read('name') +
                      box.read('contactNumber') +
                      box.read('type') +
                      box.read('breed') +
                      box.read('destination')),
              const Expanded(
                child: SizedBox(
                  height: 20,
                ),
              ),
              ButtonWidget(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  text: 'Home'),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
