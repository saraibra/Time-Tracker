import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/common_widgets/platform_alret_dialog.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/services/database.dart';

class JobPage extends StatelessWidget {
  Future<void> _confirmSignOut(BuildContext context) async {
    final deadRequestSignOut = await PlatformAlretDialog(
      title: 'Logout',
      content: 'Are sure that you want to logout ?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (deadRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context);

      await auth.signOut();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: <Widget>[
          FlatButton(
              onPressed: () => _confirmSignOut(context),
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 18),
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: () => _createJob(context)),
    );
  }

  Future<void> _createJob(BuildContext context) async {
    final database = Provider.of<Database>(context);
    await database.craeteJob(Job(name: 'Adding', ratePerHour: '10'));
  }
}
