import 'package:url_launcher/url_launcher.dart';

class SendEmailHepler {
  Future<void> contactSupportEmail({
    required String emailAddress,
    String subject = '',
    String body = '',
  }) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      queryParameters: {
        'subject': "",
        'body': "",
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email app';
    }
  }
}
