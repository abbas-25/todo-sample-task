import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:todo_sample/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Client client = Client();
  client
      .setEndpoint('https://rest.is/v1')
      .setProject('649fd19005e06ff340b2')
      .setSelfSigned(status: true);

  runApp(MyApp(client: client));
}
