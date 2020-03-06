import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/models/job.dart';

class JobListTitle extends StatelessWidget {
  const JobListTitle({Key key, @required this.job, this.onTab})
      : super(key: key);

  final Job job;
  final VoidCallback onTab;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      onTap: onTab,
      trailing: Icon(Icons.chevron_right),
    );
  }
}
