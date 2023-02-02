import 'package:shared_preferences/shared_preferences.dart';

class App {
  static App? _instance;

  late SharedPreferences prefs;

  App._internal() {
    _instance = this;
  }

  factory App() => _instance ?? App._internal();

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }
}