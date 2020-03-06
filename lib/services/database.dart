import 'package:meta/meta.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/services/api_path.dart';
import 'package:time_tracker/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Stream<List<Job>> jobsStream();
  Future<void> deleteJob(Job job) ;
}
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();
class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  String uid;
 final service = FirestoreService.instance;
 @override
  Future<void> setJob(Job job) async =>
      await service.setData(path: ApiPath.job(uid, documentIdFromCurrentDate()), data: job.toMap());
 @override
  Stream<List<Job>> jobsStream() =>service.collectionsStream(path: ApiPath.jobs(uid),
   builder: (data,documentId) =>Job.fromMap(data,documentId));
   @override
 Future<void> deleteJob(Job job) async =>
  await service.deleteData(path: ApiPath.job(uid, job.id));

}
