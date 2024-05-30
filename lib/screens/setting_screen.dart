// import 'package:flutter/material.dart';

// class SettingScreen extends StatefulWidget {
//   const SettingScreen({super.key});

//   @override
//   State<SettingScreen> createState() => _SettingScreenState();
// }

// class _SettingScreenState extends State<SettingScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:vital/constants/app_colors.dart';
import 'package:vital/constants/app_styles.dart';
import 'package:vital/utils/custom_scaffold.dart';
import 'package:vital/viewmodels/medicine_viewmodel.dart';
import 'package:vital/viewmodels/vital_viewmodel.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  VitalViewModel vitalViewModel = VitalViewModel();
  MedicineViewModel medicineViewModel = MedicineViewModel();
  late double currentTempLeft;
  late double currentTempRight;
  late double currentWeight;
  late double currentSystolic;
  late double currentDiastolic;
  late double currentPulse;
  late double pulsePressure;
  bool isValuesSet = false;
  TextStyle medicineStyle =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  bool isAlarmChecked = false;

  initVitalValues() {
    currentTempLeft = vitalViewModel.DEFAULT_TEMP_LEFT;
    currentTempRight = vitalViewModel.DEFAULT_TEMP_RIGHT;
    currentWeight = vitalViewModel.DEFAULT_WEIGHT;
    currentSystolic = vitalViewModel.DEFAULT_SYSTOLIC;
    currentDiastolic = vitalViewModel.DEFAULT_DIASTOLIC;
    currentPulse = vitalViewModel.DEFAULT_PULSE;
    pulsePressure = currentSystolic - currentDiastolic;
    return true;
  }

  bool hasValuesChanged() {
    return currentTempLeft != vitalViewModel.DEFAULT_TEMP_LEFT ||
        currentTempRight != vitalViewModel.DEFAULT_TEMP_RIGHT ||
        currentWeight != vitalViewModel.DEFAULT_WEIGHT ||
        currentSystolic != vitalViewModel.DEFAULT_SYSTOLIC ||
        currentDiastolic != vitalViewModel.DEFAULT_DIASTOLIC ||
        currentPulse != vitalViewModel.DEFAULT_PULSE;
  }

  @override
  void initState() {
    isValuesSet = initVitalValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: isValuesSet
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      _setDefaultVitalCard(context),
                      _setDefaultMedicineCard(context),
                      _setDefaultNotieeCard(context),
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
        ));
  }

  Stack _setDefaultVitalCard(BuildContext context) {
    return Stack(children: [
      Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '바이탈 초기값 설정',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              buildVitalRow(context, '체온', currentTempLeft, false, 30, 40, 100,
                  (value) {
                setState(() {
                  currentTempLeft = value;
                });
              }),
              buildVitalRow(
                  context, '체중', currentWeight, false, 45.0, 70.0, 250,
                  (value) {
                setState(() {
                  currentWeight = value;
                });
              }),
              buildVitalRow(
                  context, '혈압(수)', currentSystolic, true, 50, 200, 150,
                  (value) {
                setState(() {
                  currentSystolic = value;
                });
              }),
              buildVitalRow(
                  context, '혈압(이)', currentDiastolic, true, 20, 180, 160,
                  (value) {
                setState(() {
                  currentDiastolic = value;
                });
              }),
              buildVitalRow(context, '맥박', currentPulse, true, 50, 120, 70,
                  (value) {
                setState(() {
                  currentPulse = value;
                });
              }),
              buildVitalRow(context, '맥압기준', pulsePressure, true, 20, 100, 80,
                  (value) {
                setState(() {
                  pulsePressure = value;
                });
              }),
              hasValuesChanged()
                  ? saveButton(context)
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
      Positioned(
        right: 10,
        top: 10,
        child: IconButton(
          onPressed: () {
            setState(() {
              initVitalValues();
            });
          },
          icon: const Icon(Icons.refresh),
        ),
      )
    ]);
  }

  Row saveButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('수정된 값으로 저장할까요?'),
                        content: const Text('바이탈 입력 초기값이 새로 수정된 값으로 설정됩니다. '),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () async {
                              return Navigator.of(context).pop(false);
                            },
                            child: const Text('취소'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await vitalViewModel
                                  .setDefaultVital(
                                    tempLeft: currentTempLeft,
                                    tempRight: currentTempRight,
                                    weight: currentWeight,
                                    systolic: currentSystolic,
                                    diastolic: currentDiastolic,
                                    pulse: currentPulse,
                                  )
                                  .then((value) =>
                                      vitalViewModel.getDefaultVital());
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Successfully saved.'),
                                  ),
                                );
                                Navigator.of(context).pop(true);
                              }
                            },
                            child: const Text('확인'),
                          ),
                        ],
                      ));
            },
            child: const Text('Save'))
      ],
    );
  }

  Widget buildVitalRow(
    BuildContext context,
    String label,
    double currentValue,
    bool parseInt,
    double min,
    double max,
    int divisions,
    Function(double) onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Expanded(
          flex: 7,
          child: Slider(
            value: currentValue,
            onChanged: onChanged,
            min: min,
            max: max,
            divisions: divisions,
            label: parseInt
                ? currentValue.toStringAsFixed(0)
                : currentValue.toStringAsFixed(1),
          ),
        ),
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () =>
                _showInputDialog(context, currentValue, min, max, onChanged),
            child: Material(
              elevation: 3,
              shadowColor: Colors.purple,
              borderRadius: BorderRadius.circular(10),
              child: Center(
                child: Text(
                  parseInt
                      ? currentValue.toStringAsFixed(0)
                      : currentValue.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showInputDialog(BuildContext context, double currentValue, double min,
      double max, Function(double) onChanged) {
    final TextEditingController controller =
        TextEditingController(text: currentValue.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("값 입력"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "숫자를 입력하세요",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("취소"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("확인"),
              onPressed: () {
                double? newValue = double.tryParse(controller.text);
                if (newValue != null && newValue >= min && newValue <= max) {
                  onChanged(newValue);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _setDefaultMedicineCard(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(children: [
            Card(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '복용 약 관리',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '아침 - 기본',
                            style: medicineStyle,
                          ),
                          _buildMedicine('1. 오마코 1알 (오메가3)', true),
                          _buildMedicine('2. 디카맥스 1알 (칼슘, 비타민D)', true),
                          _buildMedicine('3. 리바로 1알 (콜레스테롤)', true),
                          _buildMedicine('4. 눈건강 2알 (루테인)', false),
                          Text(
                            '저녁 - 기본',
                            style: medicineStyle,
                          ),
                          _buildMedicine('1. 오마코 1알 (오메가3)', true),
                          _buildMedicine('2. 인자임골드 (잇몸약)', false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // [TO DO] 추후 복용약 추가 기능 구체화
            // Positioned(
            //   right: 10,
            //   top: 10,
            //   child: IconButton(
            //     onPressed: () {
            //       setState(() {
            //         initVitalValues();
            //       });
            //     },
            //     icon: const Icon(Icons.add),
            //   ),
            // ),
            Positioned(
              top: 10,
              right: 10,
              child: Row(
                children: [
                  Icon(
                    isAlarmChecked
                        ? Icons.notifications
                        : Icons.notifications_off,
                    size: 25,
                    color: Colors.purple.shade800,
                  ),
                  Switch(
                    value: isAlarmChecked,
                    // activeColor: CupertinoColors.systemPurple,
                    activeColor: Colors.purple.shade800,
                    onChanged: (bool value) {
                      Get.dialog(
                        Dialog(
                          child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Center(
                                  child: Text(isAlarmChecked
                                      ? '복용약 알림을 끕니다'
                                      : '복용약 알림을 켭니다'))),
                        ),
                      );
                      setState(() {
                        isAlarmChecked = value;
                      });
                    },
                  ),
                ],
              ),
            )
          ]),
        ],
      ),
    );
  }

  Row _buildMedicine(String title, bool isPrescripted) {
    return Row(
      children: [
        Icon(
          isPrescripted ? Icons.local_hospital : Icons.medication_liquid,
          color: isPrescripted ? Colors.red : Colors.green,
        ),
        Text(title),
      ],
    );
  }

  _setDefaultNotieeCard(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '알림 수신인 관리',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: const Text('recipient 1')),
                      const Text('recipient 1'),
                      const Text('recipient 1'),
                      const Text('recipient 1'),
                      const Text('recipient 1'),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  onPressed: () => _showNotieeInputDialog(context),
                  icon: Icon(
                    Icons.add_alert,
                    color: Colors.purple.shade800,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _showNotieeInputDialog(context) {
    final TextEditingController notieeController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("알림 수신인 등록"),
            content: TextField(
              controller: notieeController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  hintText: 'ex) abc@gmail.com',
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("취소"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
