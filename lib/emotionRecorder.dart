import 'package:flutter/material.dart';
import 'package:hwone/floor_model/emotion_recorder_entity.dart';
import 'package:hwone/floor_model/health_database.dart';
import './userActivityProvider.dart';
import 'package:provider/provider.dart';
import 'recorder_localization.dart';
import 'package:flutter/cupertino.dart';

import 'main.dart';

class EmotionRecorderApp extends StatefulWidget{
  @override
  _EmotionRecorderAppState createState() => _EmotionRecorderAppState();
}

class _EmotionRecorderAppState extends State<EmotionRecorderApp> {
  String ? emojiSelected;
  List<EmotionEntry> logEntries = [];

  //get isCupertinoDesign => MyApp.of(context)!.useCupertinoDesign;

  @override
  void initState(){
    super.initState();
    emojiSelected = null;
    _showRecord();
  }

  void _showRecord() async{
    final database = Provider.of<AppDatabase>(context, listen: false);
    final records = await database.emotionRecorderDao.listAllRecords();
    setState(() {
      logEntries = records;
    });
  }

  void _onEmojiTap(BuildContext context, String emojiInput) {
    int ptsEarned = Provider.of<UserActivityProvider>(context, listen: false).recordActivity('Emotion');
    DateTime now = DateTime.now();
    EmotionEntry newRecord = EmotionEntry(appType:'Emotion', recordedEmoji: emojiInput, recordedTime: ('${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}'), recordedPts: ptsEarned);
    _insertRecord(newRecord);
    setState(() {
      emojiSelected = null;
    });
  }

  void _insertRecord(EmotionEntry entry) async{
    final database = Provider.of<AppDatabase>(context, listen:false);
    await database.emotionRecorderDao.addEmotionEntry(entry);

    setState(() {
      logEntries.add(entry);
      emojiSelected = entry.recordedEmoji;
    });
  }
  void _deleteRecord(EmotionEntry entry) async {
    final database = Provider.of<AppDatabase>(context, listen: false);
    await database.emotionRecorderDao.removeEmotionRec(entry);
    _showRecord();
  }

  // Cupertino Widgets Section
  void _showCupertinoPicker(BuildContext context, List<String> selection) {
    final FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: selection.indexOf(emojiSelected ?? ''));
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
                    emojiSelected = selection[index];
                  });
                  },
                children: List<Widget>.generate(selection.length, (int index) {
                  return Center(
                    child: Text(
                      selection[index],
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
        );},
    );
  }

  @override
  Widget build(BuildContext context) {
    final RecorderLocalizations localizations = RecorderLocalizations.of(context);
    final bool isCupertinoDesign = MyApp.of(context)!.useCupertinoDesign;
    final List<String> emojis = [
      '😀', '😁', '😂', '🤣', '😃', '😄', '😅', '😆', '😉', '😊',
      '😋', '😎', '😍', '😘', '😗', '😙', '😚', '🙂', '🤗', '🤩',
      '🤔', '🤨', '😐', '😑',
    ];



    return Scaffold(
      appBar: AppBar(
        title:Text(localizations.translate('emotionRecorderTitle'))
      ),
      body: SafeArea(
          child: Column(
              children: [
                Text(localizations.translate('emotionRecordTxt'),
                    style: const TextStyle(fontSize:  15)),
                Text(localizations.translate('selectEmoji')),

                isCupertinoDesign
                ?DropdownButtonFormField<String>(
                  items: emojis.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    emojiSelected = newValue;
                    setState(() {
                      emojiSelected = newValue;
                    });
                  },
                )
                :CupertinoButton(
                  child: Text(emojiSelected??localizations.translate("selectEmoji")),
                  color: CupertinoColors.activeBlue,
                  onPressed: () => _showCupertinoPicker(context, emojis),

                ),

                isCupertinoDesign
                ?ElevatedButton(
                  onPressed: emojiSelected == null ? null : () => _onEmojiTap(context,emojiSelected!),
                  child:Text(localizations.translate('Submit')),
                )
                :CupertinoButton(
                    child: Text(localizations.translate('Submit')),
                    color: CupertinoColors.darkBackgroundGray,
                    onPressed: emojiSelected == null ? null : () => _onEmojiTap(context,emojiSelected!)
                )
                ,
                const Divider(),
                Text(localizations.translate('emotionalLog'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
                Expanded(
                  child:SingleChildScrollView(
                    child: Column(
                      children: logEntries.asMap().entries.map((mapEntry) {
                        int index = mapEntry.key;
                        EmotionEntry entry = mapEntry.value;
                        return ListTile(
                          title: Text(' ${localizations.translate('recordMsg')} ${entry.recordedEmoji} : ${entry.recordedTime}'),
                          trailing:
                          isCupertinoDesign
                          ?IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteRecord(entry),
                          )
                          :CupertinoButton(
                              child:Icon(CupertinoIcons.delete, color: CupertinoColors.destructiveRed),
                              onPressed:() => _deleteRecord(entry)
                          )
                          ,
                        );
                      }).toList(),
                    ),
                  )

                ),

              ]
          )
      ),
    );
  }
}