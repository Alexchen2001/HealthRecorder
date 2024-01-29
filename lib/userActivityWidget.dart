import 'package:flutter/material.dart';
import './userActivityProvider.dart';
import 'package:provider/provider.dart';

class UserActivityWidget extends StatelessWidget {
  const UserActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var activityProvider = Provider.of<UserActivityProvider>(context);
    return BottomAppBar(
      child: Padding(
        padding: EdgeInsets.zero,
        child: activityProvider.lastRecordingTime != null
            ? Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last Recorded: ${activityProvider.lastRecordingType} on ${activityProvider.lastRecordingTime}',
                style: TextStyle(fontSize: 10)),
            Text('Recording Points: ${activityProvider.recordingPoints}',
              style: TextStyle(fontSize: 10)),
            Text('Dedication Level: ${activityProvider.dedicationLevel}',
              style: TextStyle(fontSize: 10)),
            Text('Points for Next Recording: ${activityProvider.potentialPoints()}',
              style: TextStyle(fontSize: 10)),
          ],
        )
            : Text('No recent activity recorded'),
      ),
    );
  }
}
