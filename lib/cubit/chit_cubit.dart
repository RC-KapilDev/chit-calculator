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
    List<String> sp = state.map((item) => jsonEncode(item.toMap())).toList();
    print(sp);
    sharedPreferences.setStringList('noOfChit', sp);
    emit([...state, chit]);
  }

  void loadChitDataFromSharedPreference(SharedPreferences sharedPreferences) {
    List<String>? spList = sharedPreferences.getStringList('noOfChit');
    print(spList);
    if (spList == null) {
      return;
    } else {
      List<Chit> spListDecoded =
          spList.map((item) => Chit.fromMap(jsonDecode(item))).toList();
      emit([...state, ...spListDecoded]);
    }
  }

  void chitDelete(Chit chit) {
    state.remove(chit);
    emit([...state]);
  }
}
