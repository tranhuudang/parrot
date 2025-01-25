import 'package:url_launcher/url_launcher.dart';

void goToStoreListing() async {
  final Uri url = Uri.parse('ms-windows-store://pdp/?productid=9NQN1PJ0FDR1');
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}

void goToBugReport() async {
  final Uri url =
      Uri.parse('https://github.com/tranhuudang/flutter_version_manager/issues');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
