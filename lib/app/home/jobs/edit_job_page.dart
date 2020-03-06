import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/common_widgets/platform_alret_dialog.dart';
import 'package:time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker/services/database.dart';
import 'package:flutter/services.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key key, @required this.database, this.job});
  final Job job;
  final Database database;
  static Future<void> show(BuildContext context, {Job, job}) async {
    final database = Provider.of<Database>(context);
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditJobPage(
              database: database,
              job: job,
            ),
        fullscreenDialog: true));
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  int _ratePerHour;
  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  bool validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submitted() async {
    if (validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if(widget.job != null){
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_name)) {
          PlatformAlretDialog(
            title: 'name already used',
            content: 'Please enter another name',
            defaultActionText: 'ok',
          ).show(context);
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();

          final job = Job(id: id, name: _name, ratePerHour: _ratePerHour);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(title: ' Operation failed', exception: e)
            .show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job' : 'Edit job'),
        actions: <Widget>[
          FlatButton(
              onPressed: _submitted,
              child: Text(
                'Save',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ))
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormChildren(),
        ));
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        initialValue: _name,
        decoration: InputDecoration(labelText: 'Job name'),
        onSaved: (value) => _name = value,
        validator: (value) => value.isNotEmpty ? null : ' Name can\'t be empty',
      ),
      TextFormField(
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        decoration: InputDecoration(
          labelText: 'Rate per hour',
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
      ),
    ];
  }
}
