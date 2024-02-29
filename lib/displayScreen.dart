import 'package:flutter/material.dart';
import 'datamodel.dart';
import 'package:jiffy/jiffy.dart';

const ktextStyle = TextStyle(fontSize: 25);

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({super.key, required this.chit});
  final Chit chit;

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  double amount = 0;
  int monthDiff(DateTime date) {
    DateTime otherDate = date;
    DateTime now = DateTime.now();
    int yearDiff = now.year - otherDate.year;
    int monthDiff = now.month - otherDate.month;
    int totalMonthDiff = (yearDiff * 12) + monthDiff;
    return totalMonthDiff + 1;
  }

  toCalculate(Chit chit, int bid) {
    int noOfPeople = chit.people.length - monthDiff(chit.date);
    double buffer = (chit.amount * (1 / 100)) * noOfPeople;
    double deductable = chit.amount - (buffer + bid);
    double shareAmount = deductable / (chit.people.length - 1);
    return shareAmount;
  }

  bool boolean = false;
  @override
  Widget build(BuildContext context) {
    var jiffy = Jiffy.parseFromDateTime(widget.chit.date);
    var jiffy1 = jiffy.add(months: widget.chit.months);

    final TextEditingController _controllerBid = TextEditingController();
    return Material(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppBar(
              title: Text(
                widget.chit.name,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Column(
                          children: [
                            Text(
                              'Total',
                              style: ktextStyle,
                            ),
                            Text(
                              'Month',
                              style: ktextStyle,
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Row(
                          children: [
                            Text(
                              '${widget.chit.months}',
                              style: TextStyle(fontSize: 60),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 7,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Displaycard(
                      data: widget.chit.amount,
                      name: 'Amount',
                    ),
                    Displaycard(
                      data: jiffy.yM,
                      name: 'Start',
                    ),
                    Displaycard(
                      data: jiffy1.yM,
                      name: 'End',
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(20),
              width: double.infinity,
              child: const Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Text(
                    'List of People',
                    style: TextStyle(fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Container(
                    margin:
                        const EdgeInsets.only(left: 25, right: 25, bottom: 15),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _controllerBid,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter Bit Amount',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () {
                              var bid = int.tryParse(_controllerBid.text);
                              amount = toCalculate(widget.chit, bid!);
                              if (amount == 0) {
                                return;
                              } else {
                                setState(() {
                                  boolean = true;
                                });
                              }
                            },
                            child: const Text(
                              'add',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  boolean == true
                      ? ListPeople(amount, widget.chit)
                      : const Text('Please Enter a Bid'),
                ]))
          ],
        ),
      ),
    );
  }

  ListView ListPeople(double amt, Chit chit) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: chit.people.length,
      itemBuilder: (context, index) {
        return Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
            width: double.infinity,
            child: Card(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text('${chit.people[index]}'),
                          const Spacer(),
                          Text('$amt')
                        ],
                      ),
                    ))));
      },
    );
  }
}

class Displaycard extends StatelessWidget {
  Displaycard({super.key, required this.data, required this.name});

  dynamic data;
  String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Text(
              '$name $data',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
