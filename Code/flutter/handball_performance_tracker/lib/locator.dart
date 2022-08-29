import 'package:get_it/get_it.dart';
import 'package:handball_performance_tracker/services/analytics_service.dart';

final serviceLocator = GetIt.instance; // GetIt.I is also valid

void setUp(){
 //serviceLocator.registerLazySingleton<Logger>(
              // () => ConsoleLogger());
 //serviceLocator.registerSingleton<Model>(()=> MyModel());
 // register more instances
 serviceLocator.registerLazySingleton(() => FirebaseAnalyticsService());
}

