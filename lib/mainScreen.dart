import 'dart:convert';

import 'package:chit_calculator/data.dart';
import 'package:chit_calculator/datamodel.dart';
import 'package:chit_calculator/displayScreen.dart';
import 'package:flutter/material.dart';
import 'addDataScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    initSharedPreferences();
    super.initState();
  }

  initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  void saveData() {
    List<String> sp = noOfChit.map((item) => jsonEncode(item.toMap())).toList();
    sharedPreferences.setStringList('noOfChit', sp);
  }

  void loadData() {
    List<String>? spList = sharedPreferences.getStringList('noOfChit');
    if (spList == null) {
      return;
    } else {
      noOfChit = spList!.map((item) => Chit.fromMap(jsonDecode(item))).toList();
      setState(() {});
    }
  }

  void _selectedChit(Chit chit, BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DisplayScreen(chit: chit)));
  }

  void _showBottomSheet() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NameListWidget(
                  addChitData: _addChitData,
                )));
  }

  void _addChitData(Chit chit) {
    setState(() {
      noOfChit.add(chit);
      saveData();
    });
  }

  int monthCalculation(int index) {
    DateTime otherDate = noOfChit[index].date;
    DateTime now = DateTime.now();
    int yearDiff = now.year - otherDate.year;
    int monthDiff = now.month - otherDate.month;
    int totalMonthDiff = (yearDiff * 12) + monthDiff;
    print(totalMonthDiff + noOfChit[index].months);
    return totalMonthDiff + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('invest cal'),
        actions: [
          IconButton(onPressed: _showBottomSheet, icon: const Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: noOfChit.length,
          itemBuilder: (ctx, index) {
            String totalpersons = noOfChit[index].people.length.toString();
            int compeletedMonth = 0;
            compeletedMonth = monthCalculation(index);

            return GestureDetector(
              onTap: () {
                _selectedChit(noOfChit[index], context);
              },
              child: Card(
                margin: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            noOfChit[index].name,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w600),
                          ),
                          Text('Compeleted Month: $compeletedMonth'),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward)
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
