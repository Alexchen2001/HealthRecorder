import 'package:floor/floor.dart';

@Entity(tableName: "WorkoutEntry")
class WorkoutEntry{

  @PrimaryKey(autoGenerate: true)
  final int? recordID;

  final String appType;
  final String recordedWorkout;
  final String recordedAmt;
  final String recordedTime;
  final int recordedPts;

  WorkoutEntry({this.recordID,required this.appType,required this.recordedWorkout,required this.recordedAmt,required this.recordedTime,required this.recordedPts});
}
