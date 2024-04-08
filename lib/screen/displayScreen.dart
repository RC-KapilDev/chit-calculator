import 'package:chit_calculator/cubit/chit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/datamodel.dart';
import 'package:jiffy/jiffy.dart';
import 'package:chit_calculator/widgets/card_names.dart';

const ktextStyle = TextStyle(fontSize: 25);

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({super.key, required this.chit});
  final Chit chit;

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  double bufferAmount = 0;
  @override
  void initState() {
    bufferAmount = toCalculateBuffer(widget.chit);
    super.initState();
  }

  double amount = 0;
  int monthDiff(DateTime date) {
    DateTime otherDate = date;
    DateTime now = DateTime.now();
    int yearDiff = now.year - otherDate.year;
    int monthDiff = now.month - otherDate.month;
    int totalMonthDiff = (yearDiff * 12) + monthDiff;
    return totalMonthDiff + 1;
  }

  toCalculateBuffer(Chit chit) {
    int noOfPeople = chit.people.length - monthDiff(chit.date);
    double buffer = (chit.amount * (1 / 100)) * noOfPeople;
    return buffer;
  }

  toCalculate(Chit chit, int bid) {
    double buff = toCalculateBuffer(chit);
    double deductable = chit.amount - (buff + bid);
    double shareAmount = deductable / (chit.people.length);
    return shareAmount;
  }

  bool boolean = false;
  @override
  Widget build(BuildContext context) {
    var jiffy = Jiffy.parseFromDateTime(widget.chit.date);
    var jiffy1 = jiffy.add(months: widget.chit.months);

    final TextEditingController controllerBid = TextEditingController();
    return Material(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      context.read<ChitCubit>().chitDelete(widget.chit);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete))
              ],
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
                              style: const TextStyle(fontSize: 60),
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
              margin: const EdgeInsets.all(20),
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Text(
                    'Calculated Amount :  ${bufferAmount.toString()}',
                    style: const TextStyle(fontSize: 17),
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
                            controller: controllerBid,
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
                              var bid = int.tryParse(controllerBid.text);
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
                      ? ListPeople(amount.ceil(), widget.chit)
                      : const Text('Please Enter a Bid'),
                ]))
          ],
        ),
      ),
    );
  }

  ListView ListPeople(int amt, Chit chit) {
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
