import 'package:dstnotes/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog(
          context: context,
          title: "Log out",
          content: "Are you sure you want to log out?",
          optionsBuilder: () => {"Go Back": false, "log Out": true})
      .then((value) => value ?? false);
}
