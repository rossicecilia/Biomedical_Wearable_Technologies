import 'package:floor/floor.dart';
import 'package:progetto_finale/database/entities/P_access.dart';

@Entity(tableName: 'Alcool')
class Alcool {
  // @ForeignKey(childColumns: ['id'], parentColumns: ['id'], entity: P_access)
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String day;
  final String type;
  final int quantity;
  final int hour;
  final double? volume;
  final double? percentage;

  Alcool(this.id, this.day, this.type, this.quantity, this.hour, this.volume, this.percentage);
}
