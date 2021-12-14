import 'dart:io';

import 'package:flutter/material.dart';
import 'package:junior_test/ui/actions/ActionsWidget.dart';
import 'package:junior_test/ui/actions/item/ActionsItemWidget.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  // runApp(ActionsWidget());
  runApp(MaterialApp(
      home: ActionsWidget(),
    onGenerateRoute: (settings) {
      if (settings.name == ActionsItemWidget.TAG) {
        return MaterialPageRoute(
          builder: (context) => ActionsItemWidget(),
          settings: settings,);
      }
    }
  ),
  );
  // runApp(MaterialApp(
  //     home: ActionsItemWidget()));
}
