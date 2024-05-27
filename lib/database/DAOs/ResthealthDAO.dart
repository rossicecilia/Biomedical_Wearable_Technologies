import 'package:progetto_finale/database/entities/Resthealth.dart';
import 'package:floor/floor.dart';


@dao
abstract class ResthealthDAO {

  @Query('SELECT * FROM Resthealth') 
  Future<List<Resthealth>> findAllResthealth();

  @insert
  Future<void> insertResthealth(Resthealth newResthealth);

  @delete 
  Future<void> deleteResthealth(Resthealth aResthealth); 

}