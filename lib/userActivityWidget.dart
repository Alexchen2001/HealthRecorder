import 'package:flutter/material.dart';
import './userActivityProvider.dart';
import 'package:provider/provider.dart';
import 'recorder_localization.dart';

class UserActivityWidget extends StatelessWidget {
  const UserActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final RecorderLocalizations localizations = RecorderLocalizations.of(context);
    var activityProvider = Provider.of<UserActivityProvider>(context);
    return BottomAppBar(
      child: Padding(
      padding: EdgeInsets.zero,
      child: activityProvider.lastRecordingTime != null
          ? Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${localizations.translate("lastRecord")} ${activityProvider.lastRecordingType} : ${activityProvider.lastRecordingTime}',
              style: const TextStyle(fontSize: 9)),
          Text('${localizations.translate("recordingPts")} ${activityProvider.recordingPoints}',
            style: const TextStyle(fontSize: 9)),
          Text('${localizations.translate("dedicationLevel")} ${activityProvider.dedicationLevel}',
            style: const TextStyle(fontSize: 9)),
          Text('${localizations.translate("nextRecording")} ${activityProvider.potentialPoints()}',
            style: const TextStyle(fontSize: 9)),
        ],
      )
          : Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${localizations.translate("noRecord")}',
              style: const TextStyle(fontSize: 9)),
          Text('${localizations.translate("recordingPts")} ${activityProvider.recordingPoints}',
              style: const TextStyle(fontSize: 9)),
          Text('${localizations.translate("dedicationLevel")} ${activityProvider.dedicationLevel}',
              style: const TextStyle(fontSize: 9)),
          Text('${localizations.translate("nextRecording")} ${activityProvider.potentialPoints()}',
              style: const TextStyle(fontSize: 9)),

        ],
      ),
            ));
  }
}
