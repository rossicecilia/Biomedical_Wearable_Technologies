import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'DAOs/AlcoolDAO.dart';
import 'DAOs/DatahealthDAO.dart';
import 'DAOs/P_accessDAO.dart';
import 'DAOs/ResthealthDAO.dart';
import 'DAOs/StepsDAO.dart';
import 'package:progetto_finale/database/entities/Alcool.dart';
import 'package:progetto_finale/database/entities/Datahealth.dart';
import 'package:progetto_finale/database/entities/P_access.dart';
import 'package:progetto_finale/database/entities/Resthealth.dart';
import 'package:progetto_finale/database/entities/Steps.dart';

part 'database.g.dart';

@Database(version: 1, entities:[Alcool, P_access, Resthealth, Datahealth, Steps])

abstract class AppDatabase extends FloorDatabase{
  AlcoolDAO get alcoolDao;
  DatahealthDAO get datahealthDao;
  P_accessDAO get p_accessDao;
  ResthealthDAO get resthealthDao;
  StepsDAO get stepsDao;

}