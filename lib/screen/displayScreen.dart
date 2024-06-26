import 'package:chit_calculator/cubit/chit_cubit.dart';
import 'package:chit_calculator/widgets/list_people.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  double? bufferAmount;

  @override
  void initState() {
    super.initState();
    print("DisplayScreen initState: widget.chit = ${widget.chit}");
    Future<double> calculateBuffer =
        context.read<ChitCubit>().toCalculateBuffer(widget.chit);
    calculateBuffer.then((value) {
      setState(() {
        bufferAmount = value;
      });
    });
  }

  double amount = 0;

  bool boolean = false;
  @override
  Widget build(BuildContext context) {
    print(bufferAmount);
    print(widget.chit.people.length);
    var jiffy = Jiffy.parseFromDateTime(widget.chit.date);
    var jiffy1 = jiffy.add(months: widget.chit.months);
    final size = MediaQuery.of(context).size;

    final cubit = context.read<ChitCubit>();

    final TextEditingController controllerBid = TextEditingController();
    return Material(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppBar(
              actions: [
                IconButton(
                    onPressed: () async {
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      cubit.deleteChit(widget.chit, sharedPreferences);
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
            Visibility(
              visible: true,
              child: Container(
                margin: const EdgeInsets.all(20),
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: Text(
                      'Calculated Amount :  ${bufferAmount.toString()}',
                      style: const TextStyle(fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
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
                              if (bid == null) return;

                              amount = cubit.toCalculate(widget.chit, bid);

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
                      ? SizedBox(
                          width: size.width,
                          height: size.height / 2,
                          child: ListPeople(
                            amt: amount.ceil(),
                            chit: widget.chit,
                          ),
                        )
                      : const Text('Please Enter a Bid'),
                ]))
          ],
        ),
      ),
    );
  }
}
