import 'package:flutter/material.dart';
import './userActivityProvider.dart';
import 'package:provider/provider.dart';
import 'floor_model/diet_recorder_entity.dart';
import 'floor_model/health_database.dart';

import 'recorder_localization.dart';
import 'package:flutter/cupertino.dart';
import 'main.dart';


class DietRecorderApp extends StatefulWidget{
  @override
  _DietRecorderAppState createState() => _DietRecorderAppState();
}

class _DietRecorderAppState extends State<DietRecorderApp> {
  final TextEditingController _dietController = TextEditingController();
  final TextEditingController _calController = TextEditingController();
  get isCupertinoDesign => MyApp.of(context)!.useCupertinoDesign;


  String? selectedDiet;
  List<DietEntry> logEntries = [];
  Set<String> dietEntries = {};

  @override
  void initState() {
    super.initState();
    selectedDiet = null;
    _loadDietRecords();
  }

  void _loadDietRecords() async {
    final database = Provider.of<AppDatabase>(context, listen: false);
    final records = await database.dietRecorderDao.listAllRecords();
    setState(() {
      logEntries = List.from(records.reversed);
      dietEntries= records.map((record) => record.recordedDiet).toSet();
    });
  }

  void _recordDiet(DietEntry newRecord) async {
    final database = Provider.of<AppDatabase>(context, listen: false);
    await database.dietRecorderDao.addDietEntry(newRecord);
    _loadDietRecords();
    _dietController.clear();
    _calController.clear();
    selectedDiet = null;
  }

  void _removeDiet(DietEntry record) async {
    final database = Provider.of<AppDatabase>(context, listen: false);
    await database.dietRecorderDao.removeDietRec(record);
    _loadDietRecords();
  }

  void _onDietTap(BuildContext context) {
    final RecorderLocalizations localizations = RecorderLocalizations.of(context);
    if (_dietController.text.isEmpty || _calController.text.isEmpty) {
      if(MyApp.of(context)!.useCupertinoDesign){
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text(localizations.translate('warning')),
            content: Text(localizations.translate('emptyField')),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.of(context).pop(),
                child: Text(localizations.translate('Ok')),
              ),
            ],
          ),
        );
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.translate("emptyField")),
            backgroundColor: Colors.red,
          ),
        );
      }
       return;
    }


    int ptsEarned = Provider.of<UserActivityProvider>(context, listen: false).recordActivity('Diet');

    DateTime now = DateTime.now();
    String formattedTime = '${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}';


    DietEntry newRecord = DietEntry(
      appType: 'Diet',
      recordedDiet: _dietController.text,
      recordedCalorie: _calController.text,
      recordedTime: formattedTime,
      recordedPts: ptsEarned,
    );

    _recordDiet(newRecord);
  }


  void _showEditCaloriesDialog(DietEntry record) {
    final TextEditingController editCalController = TextEditingController(text: record.recordedCalorie.toString());
    final RecorderLocalizations localizations = RecorderLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return isCupertinoDesign
         ?AlertDialog(
          title: Text(localizations.translate('editCalories')),
          content: TextField(
            controller: editCalController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: localizations.translate("editCaloriesHint"),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(localizations.translate("cancel")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(localizations.translate("update")),
              onPressed: () {
                _updateDietRecordCalories(record,editCalController.text ?? record.recordedCalorie);
                Navigator.of(context).pop();
              },
            ),
          ],
        ) : CupertinoAlertDialog(
          title: Text(localizations.translate('editCalories')),
          content: CupertinoTextField(
            controller: editCalController,
            keyboardType: TextInputType.number,
            placeholder: localizations.translate('enterNewCalories'),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(localizations.translate('cancel')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(localizations.translate('update')),
              onPressed: () {
                _updateDietRecordCalories(record, editCalController.text ?? record.recordedCalorie);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateDietRecordCalories(DietEntry record, String newCalories) async {
    final database = Provider.of<AppDatabase>(context, listen: false);
    await database.dietRecorderDao.changeDietAmt(record.recordID!, newCalories);
    _loadDietRecords();
  }

  // Cupertino Widgets
  void _showCupertinoDietPicker(BuildContext context) {
    final List<String> selection = dietEntries.toList();
    final FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: selection.indexOf(selectedDiet ?? ''));

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: [
            Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: CupertinoPicker(
                scrollController: scrollController,
                itemExtent: 32,
                backgroundColor: CupertinoColors.white,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    selectedDiet = selection[index];
                    _dietController.text = selectedDiet!;
                  });
                },
                children: List<Widget>.generate(selection.length, (int index) {
                  return Center(child: Text(selection[index]));
                }),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Done'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final RecorderLocalizations localizations = RecorderLocalizations.of(context);

    return Scaffold(
      body:SafeArea(
        child:Column(
          children: [
            Text(localizations.translate('dietRecorderTitle'),style: TextStyle(fontSize: 32),),
            isCupertinoDesign?
            (dietEntries.isNotEmpty ? DropdownButton<String>(
              value: _dietController.text.isEmpty ? null : _dietController.text,
              hint: Text(localizations.translate('PrevDietLabel')),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _dietController.text = newValue;
                  });
                }
              },
              items: dietEntries.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
                : Container())
            :(dietEntries.isNotEmpty
                ? CupertinoButton(
              child: Text(selectedDiet ?? 'Select Diet'),
              onPressed: () => _showCupertinoDietPicker(context),
            )
                : Container()),
            isCupertinoDesign
            ?TextField(
              controller: _dietController,
              decoration: InputDecoration(labelText: localizations.translate('dietLabel')),
            )
            :CupertinoTextField(
                controller: _dietController,
                cursorColor: CupertinoColors.activeBlue,
                placeholder: localizations.translate('dietLabel')
            )
            ,
            isCupertinoDesign
            ?TextField(
              controller: _calController,
              decoration: InputDecoration(labelText: localizations.translate('caloriesLabel')),
              keyboardType: TextInputType.number,
            ):CupertinoTextField(
                controller: _calController,
                cursorColor: CupertinoColors.activeBlue,
                placeholder: localizations.translate('caloriesLabel')
            )
            ,
            isCupertinoDesign
            ?ElevatedButton(
              onPressed: () => _onDietTap(context), // Disable the button if conditions are not met
              child: Text(localizations.translate('Submit')),
            )
            :CupertinoButton(
                child: Text(localizations.translate('Submit')),
                color: CupertinoColors.darkBackgroundGray,
                onPressed: () => _onDietTap(context)
            )
            ,

            const Divider(),
            Text(localizations.translate("dietLogs"),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),),
            Expanded(
              child:SingleChildScrollView(
                child: Column(
                  children: logEntries.asMap().entries.map((mapEntry) {
                    int index = mapEntry.key;
                    DietEntry entry = mapEntry.value;
                    return ListTile(
                      title: Text(' ${localizations.translate('dietRMsg')}${entry.recordedDiet} ${localizations.translate('dietContMsg')} ${entry.recordedCalorie} : ${entry.recordedTime}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children:[
                          isCupertinoDesign
                          ?IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showEditCaloriesDialog(entry),
                          ):CupertinoButton(
                            onPressed: () => _showEditCaloriesDialog(entry),
                            child: Icon(CupertinoIcons.pencil, color: CupertinoColors.activeBlue),
                          ),
                          isCupertinoDesign
                          ?IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeDiet(entry), // Now passing index as well
                         ):CupertinoButton(
                              child:Icon(CupertinoIcons.delete, color: CupertinoColors.destructiveRed),
                              onPressed:() => _removeDiet(entry)
                          ),

                        ]
                      ));
                  }).toList(),
                ),
              )
            )
          ],
        )
      )
    );
  }
}
