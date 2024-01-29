// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/emotionRecorder.dart';
import '../lib/dietRecorder.dart';
import '../lib/workoutRecorder.dart';


void main() {
  testWidgets('emotionRecorder Test : Select emoji and time appear in list', (WidgetTester tester) async {

    // finds dropdown menu
    await tester.pumpWidget(MaterialApp(home:EmotionRecorderApp()));
    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    //chooses emoji
    String testEmoji = '😀';
    await tester.tap(find.text(testEmoji).last);
    await tester.pumpAndSettle();

    // clicks submit button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // checking result
    DateTime now = DateTime.now();
    expect(find.textContaining(('I feel like $testEmoji at${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}').toString()), findsOneWidget);

  });
  
  testWidgets('DietRecorder: exercise, metric and time all entered', (WidgetTester tester) async{
    // starts the app and finds the input areas
    await tester.pumpWidget(MaterialApp(home:DietRecorderApp()));
    expect(find.byType(TextField), findsWidgets);
    
    //inputs content into those areas
    String food = 'Pizza';
    String calorie = '1024';
    await tester.enterText(find.byType(TextField).at(0),food);
    await tester.enterText(find.byType(TextField).at(1), calorie);
    
    // pressing the submit button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    DateTime now = DateTime.now();
    expect(find.textContaining('Ate $food that is $calorie at${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}'),findsOneWidget);
    
  });
  
  testWidgets('Workout Recorder: ', (WidgetTester tester) async{
    //checks if has all components
    await tester.pumpWidget(MaterialApp(home:WorkoutRecorderApp()));
    expect(find.byType(DropdownButtonFormField<String>),findsOneWidget);
    expect(find.byType(TextField),findsOneWidget);
    
    // opens the dropdown menu
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    
    // chooses the desired ption
    String exercise = 'HIIT';
    await tester.tap(find.text(exercise).last);
    await tester.pumpAndSettle();
    
    // Enters the input
    String sets = '3';
    await tester.enterText(find.byType(TextField), sets);
    
    // clicks the submit button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    
    DateTime now = DateTime.now();
    expect(find.textContaining('Workout: $exercise Quantity: $sets at${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}'), findsOneWidget);
    
    

  });
}
