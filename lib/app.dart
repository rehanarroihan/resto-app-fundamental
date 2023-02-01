import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App {
  static App? _instance;
  final String? apiBaseURL;

  late SharedPreferences prefs;
  late Dio dio;

  App.configure({
    this.apiBaseURL,
  }) {
    _instance = this;
  }

  factory App() {
    if (_instance == null) {
      throw UnimplementedError("App must be configured first.");
    }

    return _instance!;
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();

    dio = Dio(BaseOptions(
      baseUrl: apiBaseURL!,
      connectTimeout: 10000,
      receiveTimeout: 50000,
      responseType: ResponseType.json
    ));
  }
}