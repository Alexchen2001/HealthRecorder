import 'package:flutter/material.dart';
import './userActivityProvider.dart';
import 'package:provider/provider.dart';
class EmotionRecorderApp extends StatefulWidget{
  @override
  _EmotionRecorderAppState createState() => _EmotionRecorderAppState();
}

class _EmotionRecorderAppState extends State<EmotionRecorderApp> {
  String ? emojiSelected;
  final List<String> logEntries = [];

  @override
  void initState(){
    super.initState();
    emojiSelected = null;
  }
  @override
  Widget build(BuildContext context) {
    final List<String> emojis = [
      '😀', '😁', '😂', '🤣', '😃', '😄', '😅', '😆', '😉', '😊',
      '😋', '😎', '😍', '😘', '😗', '😙', '😚', '🙂', '🤗', '🤩',
      '🤔', '🤨', '😐', '😑',
    ];

    return Scaffold(
      appBar: AppBar(
        title:const Text('Emotion Recorder')
      ),
      body: SafeArea(
          child: Column(
              children: [
                const Text('Record Your Emotion', style: TextStyle(fontSize:  15)),
                const Text('Select the Emoji !'),

                DropdownButtonFormField<String>(
                  items: emojis.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // Handle the change in emoji selection
                    emojiSelected = newValue;
                    setState(() {
                      emojiSelected = newValue;
                    });
                  },
                ),

                ElevatedButton(
                    onPressed: () {
                      DateTime now = DateTime.now();
                      if (emojiSelected != null){
                        setState(() {
                          logEntries.add('I feel like $emojiSelected at${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}');
                        });
                        Provider.of<UserActivityProvider>(context, listen: false).recordActivity('Emotion');
                      }
                    },
                    child: const Text('Submit')
                ),
                const Divider(),
                const Text('Logs',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                Expanded(
                  child:SingleChildScrollView(
                    child:Column(
                      children: logEntries.map((entry) => ListTile(title: Text(entry))).toList(),
                    )
                  )

                ),

              ]
          )
      ),
    );
  }
}