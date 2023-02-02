import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/app.dart';
import 'package:restaurant/common/navigation.dart';
import 'package:restaurant/utils/background_service.dart';
import 'package:restaurant/utils/date_time_helper.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  static const prefsKeyIsNotificationOn = "PREFS_KEY_IS_NOTIFICATION_ON";

  bool notifSettingOn = false;

  @override
  void initState() {
    notifSettingOn = ((App().prefs.getBool(prefsKeyIsNotificationOn) ?? false) == true) ? true : false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf9f9fb),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 24, 0, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Setting',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              child: _settingItem(
                title: 'Notifikasi',
                description: 'Dapatkan notifikasi setiap pukul 11.00',
                enabled: notifSettingOn,
                onToggle: (bool value) {
                  if (Platform.isIOS) {
                    customDialog();
                  } else {
                    _toggleNotifSetting(value);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _toggleNotifSetting(bool value) async {
    if (value) {
      await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        99,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      await AndroidAlarmManager.cancel(99);
    }

    App().prefs.setBool(prefsKeyIsNotificationOn, value);
    setState(() {
      notifSettingOn = value;
    });
  }

  Widget _settingItem({
    required String title,
    required String description,
    required bool enabled,
    required Function(bool value) onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  ),
                ),
                Text(
                  description,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: enabled,
            activeColor: Colors.orange,
            onChanged: onToggle,
          )
        ],
      ),
    );
  }

  void customDialog() {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Coming Soon!'),
          content: const Text('This feature will be coming soon!'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Ok'),
              onPressed: () {
                Navigation.back();
              },
            ),
          ],
        );
      },
    );
  }
}
