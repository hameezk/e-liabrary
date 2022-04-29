import 'package:flutter/material.dart';
import 'package:liabrary/utils/colors.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EmailHelper {
  static Future<bool> sendEmail(
    String bookname,
    String email,
    BuildContext context,
  ) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Sending Email...",
              style: TextStyle(
                color: MyColors.darkGreenColor,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    color: MyColors.darkGreenColor,
                  ),
                ),
              ],
            ),
          );
        });
    String username = 'elibraryfyp@gmail.com';
    String password = 'email.test1234';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'E-Library')
      ..recipients.add(email)
      ..subject = 'Book Overdue :: ${DateTime.now()}'
      ..text = 'Your Book bookname has been over due!';

    try {
      final sendReport = await send(message, smtpServer).then(
        (value) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: MyColors.darkGreenColor,
            duration: const Duration(seconds: 1),
            content: const Text("Email Sent Sucessfully!"),
          ),
        ),
      );
      Navigator.pop(context);
      // print('Message sent: ' + sendReport.toString());
      return true;
    } on MailerException catch (e) {
      // print('Message not sent.');
      for (var p in e.problems) {
        // print('Problem: ${p.code}: ${p.msg}');
      }
      return false;
    }
  }
}
