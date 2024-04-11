import 'package:chit_calculator/cubit/chit_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/datamodel.dart';

class NameListWidget extends StatefulWidget {
  const NameListWidget({super.key});

  @override
  NameListWidgetState createState() => NameListWidgetState();
}

class NameListWidgetState extends State<NameListWidget> {
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  List<String> names = [];
  DateTime? _selectedDate;
  int personCount = 0;

  final TextEditingController _controller = TextEditingController();

  final TextEditingController _controllerBit = TextEditingController();
  final TextEditingController _controllerMonth = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerAmount = TextEditingController();

  void _addName() {
    setState(() {
      String newName = _controller.text;
      if (newName.isNotEmpty) {
        names.add(newName);
        _controller.clear();
        personCount = personCount + 1;
      }
    });
  }

  void _deleteName(int index) {
    setState(() {
      names.removeAt(index);
      personCount = personCount - 1;
    });
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final lastDate = DateTime(now.year + 10, 1, 1);
    final firstDate = DateTime(2017, 1, 1);
    final date = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: lastDate);
    setState(() {
      _selectedDate = date;
    });
  }

  void _submitChitData() {
    final enteredMonth = int.tryParse(_controllerMonth.text);
    final enteredAmount = int.tryParse(_controllerAmount.text);
    final enteredBitDate = int.tryParse(_controllerBit.text);

    List<String> errors = [];

    // Validate input fields
    if (enteredAmount == null) {
      errors.add('Please enter a valid amount.');
    }
    if (enteredMonth == null) {
      errors.add('Please enter a valid number of months.');
    }
    if (enteredBitDate == null || enteredBitDate <= 0 || enteredBitDate > 28) {
      errors.add(
          'Please enter a valid BitDate and Bitdate Should be within 1 to 28 Date.');
    }
    if (names.isEmpty || names.length != enteredMonth) {
      errors.add(
          'Ensure number of persons should be is equal to the no.of month.');
    }
    if (_controllerName.text.isEmpty) {
      errors.add('Please enter the name of the Chit.');
    }
    if (_selectedDate == null) {
      errors.add('Please select a starting date.');
    }

    // Check if there are any validation errors
    if (errors.isNotEmpty) {
      // Show dialog with error messages
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: errors.map((error) => Text(error)).toList(),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    // All input fields are valid, proceed to add chit data
    context.read<ChitCubit>().addChit(
          Chit(
            name: _controllerName.text,
            months: enteredMonth!,
            people: names,
            amount: enteredAmount!,
            date: _selectedDate!,
            bitDate: enteredBitDate!,
          ),
          sharedPreferences,
        );

    // Clear input fields and navigate back
    _controllerName.clear();
    _controllerMonth.clear();
    _controllerAmount.clear();
    _controllerBit.clear();
    names.clear();
    _selectedDate = null;

    // Navigate back to previous screen
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerAmount.dispose();
    _controllerMonth.dispose();
    _controllerName.dispose();
    _controllerBit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: _controllerName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter the Name of the Chit',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _controllerMonth,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'No Of Month',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _controllerAmount,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Amount',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _controllerBit,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter a BitDate',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter a name',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: _addName,
                        child: const Text('Add'),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Starting Date'),
                    const Spacer(),
                    Text(_selectedDate == null
                        ? 'No Date Selected'
                        : formatter.format(_selectedDate!)),
                    const SizedBox(
                      width: 20,
                    ),
                    IconButton(
                        onPressed: _presentDatePicker,
                        icon: const Icon(Icons.calendar_month))
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _submitChitData,
                      child: const Text('Save'),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Text('Number of the Persons ${personCount.toString()}'),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors
                            .green, //const Color.fromARGB(255, 161, 170, 220)
                        width: 5),
                  ),
                  height: size.height / 4,
                  width: size.width,
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                    shrinkWrap: true,
                    itemCount: names.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(names[index]),
                            IconButton(
                                onPressed: () {
                                  _deleteName(index);
                                },
                                icon: const Icon(Icons.delete)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// Dismissible(
//                         key: Key(names[index]),
//                         onDismissed: (direction) => _deleteName(index),
//                         background: Container(
//                           color: Colors.red,
//                           alignment: Alignment.centerRight,
//                           padding: const EdgeInsets.only(right: 20),
//                           child: const Icon(Icons.delete),
//                         ),
//                         child: ListTile(
//                           title: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(names[index]),
//                               IconButton(
//                                   onPressed: () {
//                                     _deleteName(index);
//                                   },
//                                   icon: const Icon(Icons.delete)),
//                             ],
//                           ),
//                         ),
//                       );