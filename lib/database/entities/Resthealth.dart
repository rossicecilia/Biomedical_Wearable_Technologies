import 'package:floor/floor.dart';
import 'package:progetto_finale/database/entities/P_access.dart';

@Entity(tableName:'Resthealth', primaryKeys: ['id','date'],foreignKeys: [ForeignKey(childColumns: ['id'], parentColumns: ['id'], entity: P_access)])
class Resthealth{
  final int? id;
  final String date;


  final double restv;

  Resthealth(this.id, this.date, this.restv);
  
}