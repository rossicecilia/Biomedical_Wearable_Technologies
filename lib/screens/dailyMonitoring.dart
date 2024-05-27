import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:progetto_finale/screens/homePage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:progetto_finale/utils/hr.dart';
import 'package:progetto_finale/algorithms/algorithms.dart';
import 'package:progetto_finale/database/database.dart';
import 'package:progetto_finale/Repository/databaseRepository.dart';
import 'package:progetto_finale/database/entities/Alcool.dart';
import 'package:progetto_finale/database/entities/Datahealth.dart';
import 'package:progetto_finale/database/entities/Resthealth.dart';
import 'package:progetto_finale/database/entities/Steps.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_charts/flutter_charts.dart';

class DailyMonitoring extends StatefulWidget {
  const DailyMonitoring({Key? key}) : super(key: key);
  static const routename = 'DailyMonitoring';

  @override
  _stateDailyMonitoring createState() => _stateDailyMonitoring();

}

class _stateDailyMonitoring extends State<DailyMonitoring> {

  final colorList = <Color>[
    Color.fromARGB(251, 245, 224, 87),
    Color.fromARGB(231, 121, 31, 110),
    Color.fromARGB(255, 14, 96, 16),
    Color.fromARGB(255, 78, 86, 240)
  ];

  
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now().subtract(const Duration(days: 1));
    String chosen_date = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    print(chosen_date);
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(135, 47, 183, .9),
        title: const Text('Daily Monitoring', style: TextStyle(fontFamily: 'MarcellusSC', fontSize: 30),),
      ),
      body: Consumer<DatabaseRepository> (
        builder: (context, dbr, child) {
          return Column (
            children: [
              FutureBuilder<List<Datahealth>> (
                future: _getHeartDay(context, chosen_date),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return data.length == 0
                    ? Text("No Heart Rate Data avaible")
                    :
                    SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        title: ChartTitle(text: 'Daily Heart Rate', textStyle: TextStyle(color: Color.fromARGB(255, 50, 3, 59), fontFamily: 'MarcellusSC', fontSize: 16)), 
                        legend:Legend(isVisible: false),
                        series: <LineSeries<hr, int>> [
                          LineSeries(
                            dataSource: _chardata(data),
                            //creare lista di hr dai dati del db
                            xValueMapper: (hr heart_rate, _) => heart_rate.hour,
                            yValueMapper: (hr heart_rate, _) => heart_rate.value,
                          )
                        ],
                    
                      );
                      
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              FutureBuilder<List<Datahealth>> (
                future: _getHeartDay(context, chosen_date),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return data.length == 0
                    ? Text("No Heart Rate Data avaible")
                    : Container(
                      child: Text('Qui va il valore della media HR ${mean_hr(data)}'),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              FutureBuilder<List<Alcool>>(
                future: _getAlcoolDay(context, chosen_date),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return data.length == 0
                    ? Text("No Alcohol Data avaible")
                    : PieChart(
                        dataMap: _pieAlcool(data),
                        chartType: ChartType.disc,
                        baseChartColor: Colors.white,
                        colorList: colorList
                      );
                  } else {
                    return CircularProgressIndicator();
                  }
                }
              ),
              FutureBuilder(
                future: _getAlcoolDay(context, chosen_date),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return data.length == 0 
                    ? Text("No Alcool Data avaible")
                    : Container(
                      child: Text('Total grams of alcool today: ${alcool_grams_sum(alcool_grams(data))}'),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }
              ),
            ],
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(135, 47, 183, .9),
        child: const Icon(Icons.home_filled),
        onPressed: () => _backHome(context),
      ),
    );

  }


   void _backHome(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
  }

  Future<List<Alcool>> _getAlcoolDay(BuildContext context, String day_chosen) async {
    List<Alcool> alcool_list_tot = await Provider.of<DatabaseRepository>(context, listen:false).findAllAlcool();
    int num_alcool = alcool_list_tot.length;
    List<Alcool> alcool_list = []; 

    for (int bev = 0; bev < num_alcool; bev++) {
      if (alcool_list_tot[bev].day == day_chosen) {
        alcool_list.add(alcool_list_tot[bev]);
      }
    }
    return alcool_list;
  }
  
  Future<List<Steps>> _getStepDay(BuildContext context, String chosen_day) async {
    List<Steps> steps_list_tot = await Provider.of<DatabaseRepository>(context, listen:false).findAllSteps();
    int num_steps = steps_list_tot.length;
    List<Steps> steps_list = []; 

    for (int i = 0; i < num_steps; i++) {
      if (steps_list_tot[i].day == chosen_day) {
        steps_list.add(steps_list_tot[i]);
      }
    }
    return steps_list;
  }

  Future<List<Datahealth>> _getHeartDay(BuildContext context, String chosen_day) async {
    List<Datahealth> heart_list_tot = await Provider.of<DatabaseRepository>(context, listen:false).findAllDatahealth();
    int num_heart = heart_list_tot.length;
    List<Datahealth> heart_list = []; 

    for (int i = 0; i < num_heart; i++) {
      if (heart_list_tot[i].day == chosen_day) {
        heart_list.add(heart_list_tot[i]);
      }
    }
    return heart_list;
  }
  
  Future<double?> _getRestHeartDay(BuildContext context, String chosen_day) async {
    List<Resthealth> heart_list_tot = await Provider.of<DatabaseRepository>(context, listen:false).findAllResthealth();
    int num_heart = heart_list_tot.length;
    for (int i = 0; i < num_heart; i++) {
      if (heart_list_tot[i].date == chosen_day) {
        return heart_list_tot[i].restv;
      }
    }
    return null;
  }

  List<hr> _chardata(List<Datahealth> lista_hr) {
    List<hr> result = [];
    for (int el = 0; el < lista_hr.length; el++) {
      result.add(hr(lista_hr[el].hour, lista_hr[el].value));
    }
    return result;
  }

  Map<String, double> _pieAlcool(List<Alcool> alcool_lista) {
    List<String> key = ["Beer", "Wine", "Cocktail", "Other"];
    List<double> valori = alcool_grams(alcool_lista);
    //print(valori);
    Map<String, double> dataMap = {};
    for (int i = 0; i < 4; i++) {
      dataMap[key[i]] = valori[i];
    }
    //print(dataMap);
    return dataMap;
  }

}