import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './userActivityProvider.dart';
class WorkoutRecorderApp extends StatefulWidget{
  @override
  _WorkoutRecorderAppState createState() => _WorkoutRecorderAppState();
}
class _WorkoutRecorderAppState extends State<WorkoutRecorderApp> {
  String? selectedWorkout;
  String? workoutAmt;
  List<String> logEntries = [];

  @override
  void initState() {
    super.initState();
    selectedWorkout = null;
    workoutAmt = null;
  }
  @override
  Widget build(BuildContext context) {
    final List<String> woList = [
      'Running', 'Weight Lifting','HIIT','Yoga','Crossfit','Kickboxing','dance Fitness','Planks'
    ];
    return Scaffold(
      body:SafeArea(
        child:Column(
          children: [
            const Text('The Workout Recorder', style: TextStyle(fontSize:  38)),
            
            DropdownButtonFormField<String>(
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
            ),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (String value){
                setState(() {
                  workoutAmt = value;
                });

              },
            ),
            const Text('Quantity (Enter by sets'),
            ElevatedButton(
              onPressed: () {
                DateTime now = DateTime.now();
                if (selectedWorkout != null && workoutAmt != null){
                  setState(() {
                    logEntries.add('Workout: $selectedWorkout Quantity: $workoutAmt at${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}');
                    Provider.of<UserActivityProvider>(context, listen: false).recordActivity('Workout');
                  });

                }
              },
              child: const Text('Submit')
            ),

            const Divider(),
            const Text('Logs', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
            Expanded(
                child:SingleChildScrollView(
                    child: Column(
                      children: logEntries.map((entry) => ListTile(title: Text(entry))).toList(),

                    )
                )
            )


        ])
      )
    );
  }
}
