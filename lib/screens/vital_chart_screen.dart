import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vital/models/vital/vital_model.dart';
import 'package:vital/screens/add_vital_screen.dart';
import 'package:vital/utils/custom_scaffold.dart';
import 'package:vital/viewmodels/vital_viewmodel.dart';

/*
혈압 bloodpressure 
체온 temperature left/right
몸무게 weight

base 
  혈압 120-80
  몸무게 56
  체온 36.5

추세선 trend line
  1 year or 전기간 누적 
  120 days
  30 days
  7 days

default data - temperature?

*/

class _LineChart extends StatelessWidget {
  _LineChart(
      {required this.isShowingMainData,
      required this.resources,
      this.category = 'default'});
  List<VitalModel> resources;

  final bool isShowingMainData;

  // LineChartData? vitalData; //혹은 default 데이터를 혈압으로. 버튼 onpress때 setState
  String category = 'default';
  List<LineChartBarData>? _lineBarsData;
  FlTitlesData? _titleByCategory;

  @override
  Widget build(BuildContext context) {
    lineChartConverter(category);
    return LineChart(
      vitalData,
      // isShowingMainData ? dataTemperature : sampleData1,
      duration: const Duration(milliseconds: 250), //라인이 그려지는 속도
    );
  }

  setDefault() {
    _lineBarsData = lineBarsVital;
    _titleByCategory = titlesVital;
  }

  lineChartConverter(String category) {
    switch (category) {
      case "temperature":
        _lineBarsData = lineBarsDetailTemperature;
        _titleByCategory = titlesTemperature;
        break;
      case "weight":
        _lineBarsData = lineBarsDetailWeight;
        break;
      case "blood":
        _lineBarsData = lineBarsDetailBloodPressure;
        break;
      default:
        _lineBarsData = lineBarsVital;
    }
  }

  LineChartData get vitalData => LineChartData(
        lineBarsData: _lineBarsData!,
        gridData: gridData,
        // titlesData: _titleByCategory != null ? _titleByCategory! : titlesVital,
        titlesData: titlesVital,
        lineTouchData: lineTouchVital,
        maxX: resources.length.toDouble(),
        minX: 0,
        maxY: 180,
        minY: 0,
      );

  List<LineChartBarData> get lineBarsVital => [
        lineChartTemperature_left,
        lineChartTemperature_right,
        lineChartWeight,
        lineChartBlood_high,
        lineChartBlood_low,
      ];
  List<LineChartBarData> get lineBarsDetailTemperature => [
        lineChartTemperature_left,
        lineChartTemperature_right,
        horizontalGridLine(36.5),
        // lineChartWeight,
        // lineChartBlood_high,
        // lineChartBlood_low,
      ];
  List<LineChartBarData> get lineBarsDetailWeight => [
        // lineChartTemperature_left,
        // lineChartTemperature_right,
        lineChartWeight,
        horizontalGridLine(55),

        // lineChartBlood_high,
        // lineChartBlood_low,
      ];
  List<LineChartBarData> get lineBarsDetailBloodPressure => [
        lineChartBlood_high,
        lineChartBlood_low,
        lineChartPulsePressure,
        // bpLine120,
        // bpLine80,
        // bpLine40
        horizontalGridLine(40),
        horizontalGridLine(80),
        horizontalGridLine(120),
      ];

  LineChartBarData get lineChartTemperature_left => LineChartBarData(
        color: const Color.fromARGB(255, 11, 91, 14),
        barWidth: 1,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: List.generate(
          resources.length,
          (index) => FlSpot(index.toDouble(), resources[index].tempLeft),
        ),
      );

  LineChartBarData get lineChartTemperature_right => LineChartBarData(
        color: Colors.green,
        barWidth: 1,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: List.generate(
          resources.length,
          (index) => FlSpot(index.toDouble(), resources[index].tempRight),
        ),
      );
  LineChartBarData get lineChartWeight => LineChartBarData(
        color: Colors.blue,
        barWidth: 1,
        dotData: const FlDotData(show: false),
        belowBarData: category == 'weight'
            ? BarAreaData(
                show: true,
                color: Colors.red.withOpacity(0.5),
                cutOffY: 55.0,
                applyCutOffY: true)
            : BarAreaData(show: false),
        spots: List.generate(
          resources.length,
          (index) => FlSpot(index.toDouble(), resources[index].weight),
        ),
      );
  LineChartBarData get lineChartBlood_high => LineChartBarData(
        color: Colors.red,
        barWidth: 1,
        dotData: const FlDotData(show: false),
        // belowBarData: BarAreaData(
        //     show: true,
        //     color: Colors.pink.withOpacity(0.4),
        //     cutOffY: 80.0,
        //     applyCutOffY: true),
        spots: List.generate(
          resources.length,
          (index) => FlSpot(index.toDouble(), resources[index].systolic),
        ),
      );
  LineChartBarData get lineChartBlood_low => LineChartBarData(
        color: Colors.red,
        barWidth: 1,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: List.generate(
          resources.length,
          (index) => FlSpot(index.toDouble(), resources[index].diastolic),
        ),
      );

  LineChartBarData get lineChartPulsePressure => LineChartBarData(
        color: Colors.blue,
        barWidth: 1,
        dotData: const FlDotData(show: false),
        // belowBarData: BarAreaData(
        //     show: true,
        //     color: Colors.blue.shade200.withOpacity(0.4),
        //     // cutOffY: 80.0,
        //     applyCutOffY: false),
        belowBarData: BarAreaData(
            show: true,
            color: Colors.red.withOpacity(0.5),
            cutOffY: 40.0,
            applyCutOffY: true),
        aboveBarData: BarAreaData(
            show: true,
            color: Colors.blue.withOpacity(0.5),
            cutOffY: 40.0,
            applyCutOffY: true),
        spots: List.generate(
          resources.length,
          (index) => FlSpot(index.toDouble(),
              resources[index].systolic - resources[index].diastolic),
        ),
      );
  LineChartBarData get bpLine120 => LineChartBarData(
        color: Colors.grey,
        barWidth: 1,
        dotData: const FlDotData(show: false),
        spots: List.generate(
          resources.length,
          (index) => FlSpot(index.toDouble(), 120),
        ),
      );
  LineChartBarData get bpLine80 => LineChartBarData(
        color: Colors.grey,
        barWidth: 1,
        dotData: const FlDotData(show: false),
        spots: List.generate(
          resources.length,
          (index) => FlSpot(index.toDouble(), 80),
        ),
      );
  LineChartBarData get bpLine40 => LineChartBarData(
        color: Colors.grey,
        barWidth: 1,
        dotData: const FlDotData(show: false),
        spots: List.generate(
          resources.length,
          (index) => FlSpot(index.toDouble(), 40),
        ),
      );
  LineChartBarData horizontalGridLine(double interval) {
    return LineChartBarData(
      color: Colors.grey,
      barWidth: 1,
      dotData: const FlDotData(show: false),
      spots: List.generate(
        resources.length,
        (index) => FlSpot(index.toDouble(), interval),
      ),
    );
  }

  LineTouchData get lineTouchVital => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) =>
              Colors.purple.shade100.withOpacity(0.8),
        ),
      );

  LineTouchData get lineTouchTemperature => LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) =>
            Colors.purple.shade200.withOpacity(0.8),
      ));

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );
  FlTitlesData get titlesVital => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
          // axisNameWidget: const Text(
          //   '2019',
          //   style: TextStyle(
          //     fontSize: 10,
          //     color: Colors.grey,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );
  FlTitlesData get titlesTemperature => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
          axisNameWidget: const Text(
            'Temparature',
            style: TextStyle(
              fontSize: 10,
              color: Color.fromARGB(255, 71, 2, 120),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
        lineChartBarData1_3,
      ];

  LineTouchData get lineTouchData2 => const LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData2_1,
        lineChartBarData2_2,
        lineChartBarData2_3,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      // case 20:
      //   text = '20';
      //   break;
      case 36:
        text = category == 'temperature' || category == 'default'
            ? '🌡️ 36.5'
            : '';
        break;
      case 40:
        text = category == 'blood' ? '맥압 40' : '';
        break;
      case 55:
        text = category == 'weight' || category == 'default' ? '⚖️ 55kg' : '';
        break;
      case 80:
        text = category == 'blood' || category == 'default' ? '❤️ 80' : '';
        break;
      case 120:
        text = category == 'blood' || category == 'default' ? '❤️ 120' : '';
        break;
      // case 180:
      //   text = '180';
      //   break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.start);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 60, //40
      );

  Widget bottomTitleWidgets(
      double value, TitleMeta meta, List<VitalModel> resource) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    int index = value.toInt();
    if (index > 0 && index < resources.length) {
      DateTime date = DateTime.parse(resources[index].date);
      // DateTime nextDate = DateTime.parse(resources[index+1].date);
      if (index == 1 ||
          index == (resources.length / 2).ceil() ||
          index == resources.length - 1) {
        final formattedDate = '${date.month}-${date.day}';
        text = Text(
          formattedDate,
          style: style,
        );
      } else {
        text = const Text('');
      }
    } else {
      text = const Text('');
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }
  // Widget bottomTitleWidgets(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     fontWeight: FontWeight.bold,
  //     fontSize: 16,
  //   );
  //   Widget text;
  //   switch (value.toInt()) {
  //     case 1:
  //       text = const Text('1월', style: style);
  //       break;
  //     case 32:
  //       text = const Text('2월', style: style);
  //       break;
  //     case 61:
  //       text = const Text('3월', style: style);
  //     case 92:
  //       text = const Text('4월', style: style);
  //       break;
  //     case 122:
  //       text = const Text('5월', style: style);
  //       break;
  //     case 153:
  //       text = const Text('6월', style: style);
  //     case 183:
  //       text = const Text('7월', style: style);
  //       break;
  //     case 214:
  //       text = const Text('8월', style: style);
  //       break;
  //     case 245:
  //       text = const Text('9월', style: style);
  //     case 275:
  //       text = const Text('10월', style: style);
  //       break;
  //     case 306:
  //       text = const Text('11월', style: style);
  //       break;
  //     case 336:
  //       text = const Text('12월', style: style);

  //     default:
  //       text = const Text('');
  //       break;
  //   }

  //   return SideTitleWidget(
  //     axisSide: meta.axisSide,
  //     space: 10,
  //     child: text,
  //   );
  // }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: (value, meta) =>
            bottomTitleWidgets(value, meta, resources),
      );
  // SideTitles get bottomTitles => SideTitles(
  //       showTitles: true,
  //       reservedSize: 32,
  //       interval: 1,
  //       getTitlesWidget: bottomTitleWidgets,
  //     );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.purple.withOpacity(0.2), width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: Colors.green,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 1.5),
          FlSpot(5, 1.4),
          FlSpot(7, 3.4),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: Colors.pink,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          color: Colors.pinkAccent.withOpacity(0),
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
        isCurved: true,
        color: Colors.blue,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 2.8),
          FlSpot(3, 1.9),
          FlSpot(6, 3),
          FlSpot(10, 1.3),
          FlSpot(13, 2.5),
        ],
      );

  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Colors.green.withOpacity(0.5),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 4),
          FlSpot(5, 1.8),
          FlSpot(7, 5),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
      );

  LineChartBarData get lineChartBarData2_2 => LineChartBarData(
        isCurved: true,
        color: Colors.pink.withOpacity(0.5),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: Colors.pink.withOpacity(0.2),
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Colors.blue.withOpacity(0.5),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 3.8),
          FlSpot(3, 1.9),
          FlSpot(6, 5),
          FlSpot(10, 3.3),
          FlSpot(13, 4.5),
        ],
      );
}

class VitalLineChartScreen extends StatefulWidget {
  const VitalLineChartScreen({super.key});

  @override
  State<StatefulWidget> createState() => VitalLineChartState();
}

class VitalLineChartState extends State<VitalLineChartScreen> {
  late bool isShowingMainData;

  // VitalDataSource vitalDataSource = VitalDataSource();
  VitalViewModel vitalViewModel = VitalViewModel();

  String category = 'default';
  // bool selectedButton == cate = false;
  String selectedButton = '';
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // title: 'Vital Chart',
      appBar: AppBar(),
      body: SafeArea(
        child: FutureBuilder(
          future: vitalViewModel.getWholeVitalResources(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    AspectRatio(
                      // aspectRatio: 1.23,
                      aspectRatio: 1,
                      child: Stack(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const SizedBox(
                                height: 37,
                              ),
                              const Text(
                                'Vital Chart',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 68, 2, 79),
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  graphButtonTemperature('temperature'),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  graphButtonWeight('weight'),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  graphButtonBlood('blood'),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(right: 16, left: 6),
                                  child: _LineChart(
                                    isShowingMainData: isShowingMainData,
                                    resources: snapshot.data!,
                                    category: category,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.refresh,
                              color: Colors.black
                                  .withOpacity(isShowingMainData ? 1.0 : 0.5),
                            ),
                            onPressed: () {
                              setState(() {
                                // isShowingMainData = !isShowingMainData;
                                category = 'default';
                                selectedButton = '';
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),

                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => const AddVitalScreen()));
                    //   },
                    //   style: ButtonStyle(
                    //     // backgroundColor:
                    //     //     MaterialStateProperty.resolveWith<Color>((states) {
                    //     //   if (states.contains(MaterialState.pressed)) {
                    //     //     return Colors.grey.withOpacity(
                    //     //         0.8); // Change color when button is pressed
                    //     //   }
                    //     //   return Colors.purple.shade50; // Default color
                    //     // }),
                    //     shape: MaterialStateProperty.all<OutlinedBorder>(
                    //       RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(
                    //             10), // Adjust the corner radius as needed
                    //       ),
                    //     ),
                    //     padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
                    //         const EdgeInsets.symmetric(
                    //             vertical: 20, horizontal: 40)),
                    //   ),
                    //   child: const Text(
                    //     '+ Add Vital',
                    //     style: TextStyle(fontSize: 30),
                    //   ),
                    // )
                  ],
                );
              } else {
                return AlertDialog(
                    content: Text('Something is wrong ${snapshot.error}'));
              }
            }
          },
        ),
      ),
    );
  }

  ElevatedButton graphButtonTemperature(String cate) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          category = cate;
          selectedButton = cate;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedButton == cate ? Colors.grey : null,
        foregroundColor: selectedButton == cate ? Colors.white : null,
      ),
      child: const Text('체온'),
    );
  }

  ElevatedButton graphButtonWeight(String cate) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          category = cate;
          selectedButton = cate;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedButton == cate ? Colors.grey : null,
        foregroundColor: selectedButton == cate ? Colors.white : null,
      ),
      child: const Text('체중'),
    );
  }

  ElevatedButton graphButtonBlood(String cate) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          category = cate;
          selectedButton = cate;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedButton == cate ? Colors.grey : null,
        foregroundColor: selectedButton == cate ? Colors.white : null,
      ),
      child: const Text('혈압'),
    );
  }
}
