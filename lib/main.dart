import 'package:chit_calculator/cubit/chit_cubit.dart';
import 'package:chit_calculator/screen/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => ChitCubit(),
    child: const MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    ),
  ));
}
