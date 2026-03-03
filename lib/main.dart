import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:quoteoftheday/home.dart';

void main() {
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'quote_key',
      channelName: 'Quote of the Day',
      channelDescription: 'The Office QOTD',
      importance: NotificationImportance.High,
    ),
  ]);
  runApp(QuoteOfTheDay());
}

class QuoteOfTheDay extends StatefulWidget {
  const QuoteOfTheDay({super.key});

  @override
  State<QuoteOfTheDay> createState() => _QuoteOfTheDayState();
}

class _QuoteOfTheDayState extends State<QuoteOfTheDay> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote of the Day',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}
