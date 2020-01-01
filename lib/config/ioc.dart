import 'package:get_it/get_it.dart';
import 'package:sumenep_tourism/services/database.service.dart';

final GetIt ioc = GetIt.I;

class Ioc {
  static setupIocDependency() {
    ioc.registerSingleton<SqliteDbService>(new SqliteDbService());
  }

  static T get<T>() {
    return ioc<T>();
  }
}
