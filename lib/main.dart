import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'app.dart';
import 'data/db/app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  final database = AppDatabase(directory.path);
  await database.init();
  runApp(ReadingApp(database: database));
}
