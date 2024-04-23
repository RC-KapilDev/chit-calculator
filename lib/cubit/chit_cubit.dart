import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chit_calculator/model/datamodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChitCubit extends Cubit<List<Chit>> {
  ChitCubit() : super([]);

  void addChit(Chit chit, SharedPreferences sharedPreferences) {
    if (chit.name.isEmpty) {
      throw Exception('Name cannot be empty');
    }

    List<Chit> updatedChits = [...state, chit];
    _saveChitsToSharedPreferences(updatedChits, sharedPreferences);
    emit(updatedChits);
  }

  void loadChitsFromSharedPreferences(SharedPreferences sharedPreferences) {
    List<String>? encodedChits = sharedPreferences.getStringList('noOfChit');
    if (encodedChits != null) {
      List<Chit> decodedChits =
          encodedChits.map((json) => Chit.fromMap(jsonDecode(json))).toList();
      emit(decodedChits);
    }
  }

  void deleteChit(Chit chit, SharedPreferences sharedPreferences) {
    List<Chit> updatedChits = List.from(state)..remove(chit);
    _saveChitsToSharedPreferences(updatedChits, sharedPreferences);
    emit(updatedChits);
  }

  void _saveChitsToSharedPreferences(
      List<Chit> chits, SharedPreferences sharedPreferences) {
    List<String> encodedChits =
        chits.map((chit) => jsonEncode(chit.toMap())).toList();
    sharedPreferences.setStringList('noOfChit', encodedChits);
  }

  // void addChit(Chit chit, SharedPreferences sharedPreferences) {
  //   if (chit.name.isEmpty) {
  //     addError('Name cannot Empty');
  //     return;
  //   }
  //   List<Chit> updatedChits = [...state, chit];
  //   List<String> encodedChits =
  //       updatedChits.map((chit) => jsonEncode(chit.toMap())).toList();

  //   sharedPreferences.setStringList('noOfChit', encodedChits);
  //   emit(updatedChits);
  // }

  // void loadChitDataFromSharedPreference(SharedPreferences sharedPreferences) {
  //   List<String>? spList = sharedPreferences.getStringList('noOfChit');
  //   // print(spList);
  //   if (spList == null) {
  //     return;
  //   } else {
  //     List<Chit> spListDecoded =
  //         spList.map((item) => Chit.fromMap(jsonDecode(item))).toList();
  //     emit(spListDecoded);
  //   }
  // }

  // void chitDelete(Chit chit) {
  //   state.remove(chit);
  //   emit([...state]);
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

  Future<double> toCalculateBuffer(Chit chit) async {
    print("lenght of the people in cubt ${chit.people.length}");
    print("lenght of the people in cubt ${chit.amount}");
    print("lenght of the people in cubt ${monthCalculation(chit)}");
    print(
        "lenght of the people in cubt ${(chit.amount * (1 / 100)) * chit.people.length}");

    int noOfPeople = chit.people.length - monthCalculation(chit);
    double buffer = (chit.amount * (1 / 100)) * noOfPeople;
    print("buffer:$buffer");
    return buffer;
  }

  bool iscompeleted(Chit chit) {
    var monthRemaining = monthCalculation(chit);
    var totalNumberpeople = chit.people.length;
    return monthRemaining == totalNumberpeople;
  }
}
