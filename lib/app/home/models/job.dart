import 'package:meta/meta.dart';
class Job {
  final String name;
  final String ratePerHour;
  Job({
    @required this.name,
    @required this.ratePerHour
  });
  Map<String ,dynamic> toMap(){
    return {
      'name':name,
       'ratePerHour':ratePerHour
    };
  }
}