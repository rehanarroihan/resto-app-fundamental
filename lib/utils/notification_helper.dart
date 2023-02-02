import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant/common/navigation.dart';
import 'package:restaurant/models/network_response/restaurant_response.dart';
import 'package:restaurant/models/resto.dart';
import 'package:restaurant/screen/detail_screen.dart';
import 'package:rxdart/subjects.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        final payload = details.payload;
        if (payload != null) {
          print('notification payload: $payload');
        }
        selectNotificationSubject.add(payload ?? 'empty payload');
      },
    );
  }

  Future<void> showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    RestaurantResponse restos
  ) async {
    var channelId = "1";
    var channelName = "chn01";
    var channelDescription = "Resto channel";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId, channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: const DefaultStyleInformation(true, true)
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    var randomIndex = Random().nextInt(restos.restaurants!.length);
    var resto = restos.restaurants![randomIndex];

    await flutterLocalNotificationsPlugin.show(
      0,
      "<b>Featured Resto</b>",
      resto.name,
      platformChannelSpecifics,
      payload: json.encode(resto.toJson())
    );
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen((String payload) async {
        var resto = Resto.fromJson(json.decode(payload));
        Navigation.intentWithData(route, DetailScreenArgs(
          id: resto.id ?? "",
          imageId: resto.pictureId ?? "",
          restoName: resto.name ?? "",
          city: resto.city ?? "",
          rating: resto.rating ?? 0.0,
        ));
      },
    );
  }
}