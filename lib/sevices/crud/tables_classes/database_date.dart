import 'package:liftday/sevices/crud/tables_classes/database_constans.dart';

class DatabaseDate {
  final int id;
  final String digitDate;
  final String day;

  DatabaseDate({
    required this.id,
    required this.digitDate,
    required this.day,
  });

  DatabaseDate.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        digitDate = map[digitDateColumn] as String,
        day = map[dayColumn] as String;

  @override
  String toString() => "Date, ID = $id, date = $digitDate, day = $day";

  @override
  bool operator ==(covariant DatabaseDate other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
