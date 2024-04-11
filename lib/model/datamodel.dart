import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();
const uuid = Uuid();

class Chit {
  Chit(
      {required this.name,
      required this.months,
      required this.people,
      required this.date,
      required this.amount,
      required this.bitDate})
      : id = uuid.v4();

  final int months;
  final String id;
  int bitDate;
  final String name;
  final List people;
  final DateTime date;
  final int amount;

  String get formattedDate {
    return formatter.format(date);
  }

  Chit.fromMap(Map map)
      : name = map['name'],
        months = map['months'],
        people = map['people'],
        amount = map['amount'],
        date = DateTime.parse(map['date']),
        bitDate = map['bitdate'],
        id = map['id'];

  Map toMap() {
    return {
      'name': name,
      'months': months,
      'people': people,
      'amount': amount,
      'date': date.toIso8601String(),
      'bitdate': bitDate,
      'id': id
    };
  }
}
