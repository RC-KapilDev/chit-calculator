import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chit_calculator/model/datamodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChitCubit extends Cubit<List<Chit>> {
  ChitCubit() : super([]);

  void addChit(Chit chit, SharedPreferences sharedPreferences) {
    if (chit.name.isEmpty) {
      addError('Name cannot Empty');
      return;
    }
    List<String> sp =
        [...state, chit].map((item) => jsonEncode(item.toMap())).toList();
    print(chit.id);
    sharedPreferences.setStringList('noOfChit', sp);
    emit([...state, chit]);
  }

  void loadChitDataFromSharedPreference(SharedPreferences sharedPreferences) {
    List<String>? spList = sharedPreferences.getStringList('noOfChit');
    // print(spList);
    if (spList == null) {
      return;
    } else {
      List<Chit> spListDecoded =
          spList.map((item) => Chit.fromMap(jsonDecode(item))).toList();
      emit(spListDecoded);
    }
  }

  void chitDelete(Chit chit) {
    state.remove(chit);
    emit([...state]);
  }

// operations in chit calculator

  // int monthDiff(DateTime date) {
  //   DateTime otherDate = date;
  //   DateTime now = DateTime.now();
  //   int yearDiff = now.year - otherDate.year;
  //   int monthDiff = now.month - otherDate.month;
  //   int totalMonthDiff = (yearDiff * 12) + monthDiff;
  //   return totalMonthDiff + 1;
  // }

  int monthCalculation(Chit chit) {
    DateTime otherDate = chit.date;
    DateTime now = DateTime.now();
    int yearDiff = now.year - otherDate.year;
    int monthDiff = now.month - otherDate.month;
    int totalMonthDiff = (yearDiff * 12) + monthDiff;
    // print(totalMonthDiff + chit.months);
    return totalMonthDiff + 1;
  }

  double toCalculate(Chit chit, int bid) {
    int noOfPeople = chit.people.length - monthCalculation(chit);
    if (noOfPeople <= 1) {
      return 0.0;
    }
    int buffer = (chit.amount * (1 / 100)).toInt() * noOfPeople;
    int deductable = chit.amount - (buffer + bid);
    double shareAmount = deductable / (chit.people.length - 1);
    return shareAmount;
  }

  toCalculateBuffer(Chit chit) {
    int noOfPeople = chit.people.length - monthCalculation(chit);
    double buffer = (chit.amount * (1 / 100)) * noOfPeople;
    return buffer;
  }
}
