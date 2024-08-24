import 'package:liftday/sevices/crud/database_constans.dart';

class DatabaseDate {
  final int id;
  final String date;
  final String day;

  DatabaseDate({
    required this.id,
    required this.date,
    required this.day,
  });

  DatabaseDate.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        date = map[dateColumn] as String,
        day = map[dayColumn] as String;

  @override
  String toString() => "Date, ID = $id, date = $date, day = $day";

  @override
  bool operator ==(covariant DatabaseDate other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
