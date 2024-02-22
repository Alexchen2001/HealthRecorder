import 'package:floor/floor.dart';

@Entity(tableName: "EmotionEntry")
class EmotionEntry{

  @PrimaryKey(autoGenerate:true)
  final int? recordID;

  final String appType;
  final String recordedEmoji;
  final String recordedTime;
  final int recordedPts;

  EmotionEntry({this.recordID,required this.appType, required this.recordedEmoji,required this.recordedTime, required this.recordedPts});

}