import 'package:flutter/material.dart';
import 'package:flutter_version_manager/src/core/core.dart';
import 'package:url_launcher/url_launcher.dart';

class PaypalDonationWidget extends StatefulWidget {
  const PaypalDonationWidget({super.key});

  @override
  State<PaypalDonationWidget> createState() => _PaypalDonationWidgetState();
}

class _PaypalDonationWidgetState extends State<PaypalDonationWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          _launchURL(OnlineDirectory.paypalLink);
        },
        child: Container(
            width: 156,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Image.asset(
              'assets/donation/paypal-donate-button.png',
            )));
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
