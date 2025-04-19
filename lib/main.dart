// Entry point for the Flutter app using BLoC, Dio, Hive, and Clean Architecture

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/app.dart';
import 'src/core/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('user_cache');
  setupDependencies();
  runApp(MyApp());
}
