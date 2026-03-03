import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? qotd;
  String? character;

  Future<void> getQuoteOftheDay() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Response quoteResponse = await get(
        Uri.parse('https://theofficelines.com/data/qotd.json'),
      );
      Map quote = jsonDecode(quoteResponse.body);
      setState(() {
        qotd = quote["quote"]["line"].toString();
        character = quote["quote"]["character"].toString();
      });

      prefs.setString('cached_qotd', qotd.toString());
      prefs.setString('cached_character', character.toString());
    } catch (e) {
      setState(() {
        qotd = prefs.getString('cached_qotd') ?? "Dwight, You Ignorant Slut!";
        character = prefs.getString('cached_character') ?? "Michael";
      });
    }
    await getQOTDNotification();
  }

  Future<void> getQOTDNotification() async {
    String localTimeZone = await AwesomeNotifications()
        .getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'quote_key',
        title: character ?? "Loading character...",
        body: qotd ?? "Loading quote...",
      ),
      schedule: NotificationCalendar(
        hour: 20,
        minute: 30,
        second: 0,
        timeZone: localTimeZone,
        repeats: true,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getQuoteOftheDay();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    getQuoteOftheDay().then((_) {
      getQOTDNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(qotd ?? 'Loading...')));
  }
}
