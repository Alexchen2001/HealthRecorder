import 'package:floor/floor.dart';
import 'package:hwone/floor_model/diet_recorder_entity.dart';
import 'workout_recorder_entity.dart';

@dao
abstract class WorkoutRecorderDao{

  // creates new entry (create)
  @insert
  Future<void> addWorkoutEntry(WorkoutEntry entry);
  // retrieves all entry (Read)
  @Query('SELECT * FROM WorkoutEntry')
  Future<List<WorkoutEntry>> listAllRecords();
  @Query('SELECT COUNT(*) FROM WorkoutEntry')
  Future<int?> getCountOfAllEntry();
  //Update entry data (Update)
  @Query('UPDATE WorkoutEntry SET recordedAmt = :newVal WHERE recordID = :cRecord')
  Future<int?> changeWorkoutAmt(int newVal, int cRecord);
  //Sum of all entry points
  @Query('SELECT COALESCE(SUM(recordedPts), 0) FROM WorkoutEntry')
  Future<int?> getSumOfPoints();
  // finds the last record
  @Query('SELECT * FROM WorkoutEntry ORDER BY recordID DESC LIMIT 1')
  Future<WorkoutEntry?> getLastRecord();
  //Deleting selected entry (Delete)
  @delete
  Future<int?> removeWorkoutRec(WorkoutEntry entry);

}