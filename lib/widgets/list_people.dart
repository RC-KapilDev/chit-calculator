import 'package:chit_calculator/model/datamodel.dart';
import 'package:flutter/material.dart';

class ListPeople extends StatelessWidget {
  const ListPeople({super.key, required this.amt, required this.chit});
  final int amt;
  final Chit chit;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: chit.people.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
          width: double.infinity,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text('${chit.people[index]}'),
                    const Spacer(),
                    Text('$amt')
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
