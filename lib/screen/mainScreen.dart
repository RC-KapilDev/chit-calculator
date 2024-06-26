import 'package:chit_calculator/cubit/chit_cubit.dart';
import 'package:chit_calculator/model/datamodel.dart';
import 'package:chit_calculator/screen/displayScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'addDataScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    print("initsate here");
    initSharedPreferences();
    super.initState();
  }

  initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    context.read<ChitCubit>().loadChitsFromSharedPreferences(sharedPreferences);
  }

  void _selectedChit(Chit chit, BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DisplayScreen(chit: chit)));
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChitCubit>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NameListWidget()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Chit Calculator'),
      ),
      body: BlocBuilder<ChitCubit, List<Chit>>(
        builder: (context, chits) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: chits.length,
              itemBuilder: (ctx, index) {
                print("len,${chits.length}");
                // print(chits[index].name);
                // String totalpersons = chits[index].people.length.toString();
                int compeletedMonth = 0;
                compeletedMonth = cubit.monthCalculation(chits[index]);
                return GestureDetector(
                  onTap: () {
                    _selectedChit(chits[index], context);
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
                                chits[index].name,
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
              });
        },
      ),
    );
  }
}
