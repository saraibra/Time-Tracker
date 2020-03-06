import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker/app/home/jobs/empty_content.dart';
import 'package:time_tracker/app/home/jobs/job_list_title.dart';
import 'package:time_tracker/app/home/jobs/list_item_builder.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/common_widgets/platform_alret_dialog.dart';
import 'package:time_tracker/common_widgets/platform_exception_alert_dialog.dart';
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
        body: _buildContents(context),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => EditJobPage.show(context),
        ));
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Job>>(
      builder: (context, snapshot) {
        return ListItemBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            key: Key('job-${job.id}'),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, job),
            background: Container(
              color: Colors.red,
            ),
            child: JobListTitle(
              job: job,
              onTab: () => EditJobPage.show(context, job: job),
            ),
          ),
        );
      },
      stream: database.jobsStream(),
    );
  }

  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context);
      await database.deleteJob(job);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(title: ' Operation failed', exception: e)
          .show(context);
    }
  }
}
