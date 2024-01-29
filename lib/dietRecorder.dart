import 'package:flutter/material.dart';
import './userActivityProvider.dart';
import 'package:provider/provider.dart';

class DietRecorderApp extends StatefulWidget{
  @override
  _DietRecorderAppState createState() => _DietRecorderAppState();
}
class _DietRecorderAppState extends State<DietRecorderApp> {
  String? dietInput;
  String? calorieInput;
  String? selectedDiet;
  final List<String> logEntries = [];
  final Set<String> dietEntries = Set();

  @override
  void initState() {
    super.initState();
    dietInput = null;
    calorieInput = null;
    selectedDiet = null;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:SafeArea(
        child:Column(
          children: [
            const Text('The Diet Recorder',style: TextStyle(fontSize: 32),),
            dietEntries.isNotEmpty ? DropdownButton<String>(
              value: selectedDiet,
              hint: const Text('Select Previous Diet'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedDiet = newValue;
                  dietInput = newValue;
                });
              },
              items: dietEntries.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
                : Container(),
            TextField(
              keyboardType: TextInputType.text,
              onChanged: (String value){
                setState(() {
                    dietInput = value;
                  });
              },
            ),
            const Text('Diet Description'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (String value){
                setState(() {
                  calorieInput = value;
                });
              },
            ),
            const Text('Calorie Amount'),
            ElevatedButton(
              onPressed: () {
                DateTime now = DateTime.now();
                setState(() {
                  if (dietInput != null && calorieInput != null){
                    logEntries.add('Ate $dietInput that is $calorieInput at${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}');
                    dietEntries.add(dietInput!);
                  }
                });
                Provider.of<UserActivityProvider>(context, listen: false).recordActivity('Diet');
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
          ],
        )
      )
    );
  }
}
