import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class ExerciseService {
  Database? _db;

  static final ExerciseService _shared = ExerciseService._sharedInstance();
  ExerciseService._sharedInstance();
  factory ExerciseService() => _shared;
  //singleton
}
