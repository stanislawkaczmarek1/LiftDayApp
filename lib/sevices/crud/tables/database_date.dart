import 'package:liftday/constants/database.dart';

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
  String toString() => "Date, ID = $id, digitDate = $digitDate, day = $day";

  @override
  bool operator ==(covariant DatabaseDate other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
