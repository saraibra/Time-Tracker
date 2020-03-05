import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:time_tracker/app/home/models/job.dart';

abstract class Database
 {
  Future <void> craeteJob(Job job);
}
class FirestoreDatabase implements Database {
FirestoreDatabase({@required this.uid}) :assert(uid !=null);
  String uid;
  
 Future <void> craeteJob(Job job) async{
    final path = '/users/$uid/jobs/job_abc';
    final documentReference = Firestore.instance.document(path);
   await documentReference.setData(job.toMap());

  }
}