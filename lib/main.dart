import 'package:progetto_finale/database/database.dart';
import 'package:flutter/material.dart';
import 'package:progetto_finale/screens/loginPage.dart';
import 'package:progetto_finale/Repository/databaseRepository.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AppDatabase database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  final databaseRepository = DatabaseRepository(database: database);

  runApp(ChangeNotifierProvider<DatabaseRepository>(
    create: (context) => databaseRepository,
    child: const MyApp(),
  ));
} //main

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: LoginPage());
  } //build
}//MyApp

