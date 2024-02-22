import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './userActivityProvider.dart';

import 'floor_model/workout_recorder_entity.dart';
import 'floor_model/health_database.dart';

import 'recorder_localization.dart';
import 'package:flutter/cupertino.dart';
import 'main.dart';

class WorkoutRecorderApp extends StatefulWidget{
  @override
  _WorkoutRecorderAppState createState() => _WorkoutRecorderAppState();
}
class _WorkoutRecorderAppState extends State<WorkoutRecorderApp> {
  String? selectedWorkout;
  final TextEditingController _workoutAmtController = TextEditingController();
  List<WorkoutEntry> logEntries = [];

  get isCupertinoDesign => MyApp.of(context)!.useCupertinoDesign;

  @override
  void initState() {
    super.initState();
    selectedWorkout = null;
    _showRecord();

  }
  @override
  void dispose() {
    // Dispose the controller when the widget is removed from the widget tree
    _workoutAmtController.dispose();
    super.dispose();
  }


  void _showRecord() async{
    final database = Provider.of<AppDatabase>(context, listen: false);
    final records = await database.workoutRecorderDao.listAllRecords();
    setState(() {
      logEntries = records;
    });
  }

  void _onWkTap(BuildContext context, String wInput) {
    final RecorderLocalizations localizations = RecorderLocalizations.of(context);
    if (_workoutAmtController.text.isEmpty || selectedWorkout == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.translate("emotyField")),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    int ptsEarned = Provider.of<UserActivityProvider>(context, listen: false).recordActivity('Emotion');
    DateTime now = DateTime.now();
    WorkoutEntry newRecord = WorkoutEntry(
        appType:'Workout',
        recordedWorkout: wInput,
        recordedAmt: _workoutAmtController.text,
        recordedTime: ('${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}'),
        recordedPts: ptsEarned);
    _insertRecord(newRecord);
    setState(() {
      selectedWorkout = null;
    });
  }

  void _insertRecord(WorkoutEntry entry) async{
    final database = Provider.of<AppDatabase>(context, listen:false);
    await database.workoutRecorderDao.addWorkoutEntry(entry);

    setState(() {
      logEntries.add(entry);
      selectedWorkout= entry.recordedWorkout;
    });

    _workoutAmtController.clear();
  }
  void _deleteRecord(WorkoutEntry entry) async {
    final database = Provider.of<AppDatabase>(context, listen: false);
    await database.workoutRecorderDao.removeWorkoutRec(entry);
    _showRecord();
  }

  // Cupertino Widgets
  void _showCupertinoWorkoutPicker(BuildContext context, List<String> woList) {
    final FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: woList.indexOf(selectedWorkout ?? ''));

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: [
            Container(
              height: 216, // The default height of a CupertinoPicker
              padding: const EdgeInsets.only(top: 6.0),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: CupertinoPicker(
                scrollController: scrollController,
                itemExtent: 32, // Height for each item
                backgroundColor: CupertinoColors.white,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    selectedWorkout = woList[index];
                  });
                },
                children: List<Widget>.generate(woList.length, (int index) {
                  return Center(
                    child: Text(
                      woList[index],
                    ),
                  );
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
    final List<String> woList = [
      localizations.translate("running"),
      localizations.translate("weightLifting"),
      localizations.translate("HIIT"),
      localizations.translate("Yoga"),
      localizations.translate("crossFit"),
      localizations.translate("kickBoxing"),
      localizations.translate("danceFit"),
      localizations.translate("planks")
    ];
    return Scaffold(
      body:SafeArea(
        child:Column(
          children: [
            Text(localizations.translate("workoutRecorderTitle"), style: TextStyle(fontSize:  38)),

            isCupertinoDesign
            ?DropdownButtonFormField<String>(
                items: woList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue){
                  setState(() {
                    selectedWorkout = newValue;
                  });
                },
            ): CupertinoButton(
              child: Text(selectedWorkout ?? 'Select Workout'),
              onPressed: () => _showCupertinoWorkoutPicker(context, woList),
            ),
            isCupertinoDesign
            ?TextField(
              controller: _workoutAmtController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: localizations.translate("setAmount"),
              ),
            ):CupertinoTextField(
                controller: _workoutAmtController,
                cursorColor: CupertinoColors.activeBlue,
                placeholder: localizations.translate('setAmount')
            )
            ,
            Text(localizations.translate("setAmount")),
            isCupertinoDesign
            ?ElevatedButton(
              onPressed: () => _onWkTap(context, selectedWorkout!), // Disable the button if conditions are not met
              child: Text(localizations.translate("Submit")),
            ): CupertinoButton(
                child: Text(localizations.translate('Submit')),
                color: CupertinoColors.darkBackgroundGray,
                onPressed: () => _onWkTap(context, selectedWorkout!)
            )
            ,

            const Divider(),
            Text(localizations.translate("workoutLogs"),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),),
            Expanded(
                child:SingleChildScrollView(
                  child: Column(
                    children: logEntries.asMap().entries.map((mapEntry) {
                      int index = mapEntry.key;
                      WorkoutEntry entry = mapEntry.value;
                      return ListTile(
                        title: Text('Workout: ${entry.recordedWorkout} Quantity: ${entry.recordedAmt} at${entry.recordedTime}'),
                        trailing:
                        isCupertinoDesign
                        ?IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteRecord(entry),
                        ):CupertinoButton(
                            child:Icon(CupertinoIcons.delete, color: CupertinoColors.destructiveRed),
                            onPressed:() => _deleteRecord(entry)
                        ),
                      );
                    }).toList(),
                  ),
                )
            )


        ])
      )
    );
  }
}
