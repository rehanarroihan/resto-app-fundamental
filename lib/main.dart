import 'package:flutter/material.dart';

import 'app.dart';
import 'main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  App.configure(
    apiBaseURL: 'https://restaurant-api.dicoding.dev/',
  );

  await App().init();

  runApp(const MainApp());
}
