import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? qotd;

  void getQuoteOftheDay() async {
    try {
      Response quoteResponse = await get(
        Uri.parse('https://theofficelines.com/data/qotd.json'),
      );
      Map quote = jsonDecode(quoteResponse.body);
      setState(() {
        qotd =
            "${quote["quote"]["line"].toString()} - ${quote["quote"]["character"]}";
      });
    } catch (e) {
      setState(() {
        qotd = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getQuoteOftheDay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(qotd ?? 'Loading...')));
  }
}
