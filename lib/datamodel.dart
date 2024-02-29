import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();
final uuid = Uuid();

class Chit {
  Chit(
      {required this.name,
      required this.months,
      required this.people,
      required this.date,
      required this.amount});

  final int months;
  final String name;
  final List people;
  final DateTime date;
  final int amount;

  String get formattedDate {
    return formatter.format(date);
  }

  int monthDiff(DateTime date) {
    DateTime otherDate = date;
    DateTime now = DateTime.now();
    int yearDiff = now.year - otherDate.year;
    int monthDiff = now.month - otherDate.month;
    int totalMonthDiff = (yearDiff * 12) + monthDiff;
    return totalMonthDiff + 1;
  }

  toCalculate(Chit chit, int bid) {
    int noOfPeople = chit.people.length - monthDiff(chit.date);
    int buffer = (chit.amount * (1 / 100) as int) * noOfPeople;
    int deductable = chit.amount - (buffer + bid);
    double shareAmount = deductable / (chit.people.length - 1);
    print(shareAmount);
  }

  Chit.fromMap(Map map)
      : this.name = map['name'],
        this.months = map['months'],
        this.people = map['people'],
        this.amount = map['amount'],
        this.date = DateTime.parse(map['date']);

  Map toMap() {
    return {
      'name': this.name,
      'months': this.months,
      'people': this.people,
      'amount': this.amount,
      'date': this.date.toIso8601String(),
    };
  }
}
