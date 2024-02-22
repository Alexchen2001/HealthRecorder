import 'package:floor/floor.dart';
import 'diet_recorder_entity.dart';

@dao
abstract class DietRecorderDao{

  // creates new entry (create)
  @insert
  Future<void> addDietEntry(DietEntry entry);
  // retrieves all entry (Read)
  @Query('SELECT * FROM DietEntry')
  Future<List<DietEntry>> listAllRecords();
  @Query('SELECT COUNT(*) FROM DietEntry')
  Future<int?> getCountOfAllEntry();
  //Update entry data (Update)
  @Query('UPDATE DietEntry SET recordedCalorie = :cRecord WHERE recordID = :idVal')
  Future<int?> changeDietAmt(int idVal, String cRecord);
  //Sum of all entry points
  @Query('SELECT COALESCE(SUM(recordedPts), 0) FROM DietEntry')
  Future<int?> getSumOfPoints();
  // finds the last record
  @Query('SELECT * FROM DietEntry ORDER BY recordID DESC LIMIT 1')
  Future<DietEntry?> getLastRecord();
  //Deleting selected entry (Delete)
  @delete
  Future<int?> removeDietRec(DietEntry entry);

}

