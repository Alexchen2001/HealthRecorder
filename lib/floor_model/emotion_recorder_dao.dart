import 'package:floor/floor.dart';
import 'emotion_recorder_entity.dart';

@dao
abstract class EmotionRecorderDao{

  // creates new entry (create)
  @insert
  Future<void> addEmotionEntry(EmotionEntry entry);
  // retrieves all entry (Read)
  @Query('SELECT * FROM EmotionEntry')
  Future<List<EmotionEntry>> listAllRecords();
  //Count all entries
  @Query('SELECT COUNT(*) FROM EmotionEntry')
  Future<int?> getCountOfAllEntry();
  //Sum of all entry points
  @Query('SELECT COALESCE(SUM(recordedPts), 0) FROM EmotionEntry')
  Future<int?> getSumOfPoints();
  // finds the last record
  @Query('SELECT * FROM EmotionEntry ORDER BY recordID DESC LIMIT 1')
  Future<EmotionEntry?> getLastRecord();
  //Deleting selected entry (Delete)
  @delete
  Future<int?> removeEmotionRec(EmotionEntry entry);
}