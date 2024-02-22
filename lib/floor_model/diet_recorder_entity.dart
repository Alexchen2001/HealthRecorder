import 'package:floor/floor.dart';

@Entity(tableName: "DietEntry")
class DietEntry{

  @PrimaryKey(autoGenerate: true)
  final int? recordID;

  final String appType;
  final String recordedDiet;
  final String recordedCalorie;
  final String recordedTime;
  final int recordedPts;

  DietEntry({this.recordID ,required this.appType,required this.recordedDiet,required this.recordedCalorie,required this.recordedTime,required this.recordedPts});
}