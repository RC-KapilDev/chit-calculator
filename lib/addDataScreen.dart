import 'package:flutter/material.dart';
import 'datamodel.dart';

class NameListWidget extends StatefulWidget {
  const NameListWidget({super.key, required this.addChitData});
  final void Function(Chit chit) addChitData;
  @override
  NameListWidgetState createState() => NameListWidgetState();
}

class NameListWidgetState extends State<NameListWidget> {
  List<String> names = [];
  DateTime? _selectedDate;
  int personCount = 0;

  final TextEditingController _controller = TextEditingController();
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
    final entredMonth = int.tryParse(_controllerMonth.text);
    final entredAmount = int.tryParse(_controllerAmount.text);
    if (entredMonth! <= 0 ||
        _selectedDate == null ||
        names.isEmpty ||
        _controllerName.text == "" ||
        _controllerAmount.text == "") {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Invalid Input'),
                content: const Text(
                    'please make sure a valid month , starting date , atleast one person is included '),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Okay'))
                ],
              ));
    }
    widget.addChitData(Chit(
        name: _controllerName.text,
        months: entredMonth,
        people: names,
        amount: entredAmount!,
        date: _selectedDate!));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 20),
              Text('Number of the Persons ${personCount.toString()}'),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: names.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(names[index]),
                    onDismissed: (direction) => _deleteName(index),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete),
                    ),
                    child: ListTile(
                      title: Text(names[index]),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
