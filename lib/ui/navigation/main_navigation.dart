import 'package:flutter/cupertino.dart';

class MainNavigation{
  static void showLoader(BuildContext context) =>
    Navigator.of(context).pushNamedAndRemoveUntil('loader', (_) => false);
}