import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:vital/constants/constants.dart';
import 'package:vital/models/vital/vital_model.dart';
import 'package:vital/viewmodels/vital_viewmodel.dart';

class UpdateVitalScreen extends StatefulWidget {
  const UpdateVitalScreen({super.key});

  @override
  State<UpdateVitalScreen> createState() => _UpdateVitalScreenState();
}

class _UpdateVitalScreenState extends State<UpdateVitalScreen> {
  DateTime date = DateTime.now();
  TimeOfDay initialTime = const TimeOfDay(hour: 6, minute: 30);
  late double temperatureLeft;
  late double temperatureRight;
  late double bloodPressureHigh;
  late double bloodPressureLow;
  late double weight;
  late double pulse;
  // double defaultValue = 0;
  String? errorMessage;
  Color containerColor = Colors.purple.shade50;
  bool isUpdateSelected = false;
  bool isDateAndTimeSelected = false;

  setInitialValue() {
    temperatureLeft = TEMP_DEFAULT;
    temperatureRight = TEMP_DEFAULT;
    bloodPressureHigh = SYSTOLIC_DEFAULT.toDouble();
    bloodPressureLow = DIASTOLIC_DEFAULT.toDouble();
    weight = WEIGHT_DEFAULT.toDouble();
  }

  TextStyle plusMinusStyle =
      // const TextStyle(
      //   fontSize: 30,
      //   color: Colors.purpleAccent,
      // );

      const TextStyle(
    color: Color.fromARGB(255, 78, 4, 91),
    fontSize: 30,
    fontWeight: FontWeight.w900,
  );
  @override
  Widget build(BuildContext context) {
    VitalViewModel vitalViewModel = VitalViewModel();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isUpdateSelected = !isUpdateSelected;
                });
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: Row(
                  children: [
                    Flexible(
                      // fit: FlexFit.tight,
                      // flex: 3,
                      child: InkWell(
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(2014),
                            lastDate: DateTime.now(),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              date = selectedDate;
                              setInitialValue();
                            });
                          }
                        },
                        child: const Icon(
                          Icons.calendar_month,
                          color: Color.fromARGB(255, 78, 4, 91),
                        ),
                      ),
                    ),
                    Expanded(
                      // fit: FlexFit.loose,
                      // flex: 10,
                      child: Column(
                        children: [
                          const Text('Date 날짜'),
                          Text(date.toString().split(' ')[0]),
                        ],
                      ),
                    ),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    Flexible(
                        child: InkWell(
                      onTap: () async {
                        final selectedTime = await showTimePicker(
                            context: context, initialTime: initialTime);
                        if (selectedTime != null) {
                          setState(() {
                            initialTime = selectedTime;
                            setInitialValue();
                          });
                        }
                      },
                      child: const Icon(Icons.av_timer),
                    )),
                    Expanded(
                      // fit: FlexFit.loose,
                      // flex: 10,
                      child: Column(
                        children: [
                          const Text('Time 시간'),
                          Text(date.toString().split(' ')[1].substring(0, 8)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              isDateAndTimeSelected
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 78, 4, 91),
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            isUpdateSelected
                                ? InkWell(
                                    onTap: () async {
                                      final selectedDate = await showDatePicker(
                                        context: context,
                                        initialDate: date,
                                        firstDate: DateTime(2014),
                                        lastDate: DateTime.now(),
                                      );
                                      if (selectedDate != null) {
                                        setState(() {
                                          date = selectedDate;
                                          setInitialValue();
                                        });
                                      }
                                    },
                                    child: const Icon(
                                      Icons.calendar_month,
                                      color: Color.fromARGB(255, 78, 4, 91),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        makeVitalPickerWidget(title: '체온(좌)'),
                        const SizedBox(
                          height: 10,
                        ),
                        makeVitalPickerWidget(title: '체온(우)'),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          thickness: 1,
                          height: 1,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        makeVitalPickerWidget(
                          title: '체중',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          thickness: 1,
                          height: 1,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        makeVitalPickerWidget(title: '혈압(수축기)'),
                        const SizedBox(
                          height: 10,
                        ),
                        makeVitalPickerWidget(title: '혈압(이완기)'),
                        const SizedBox(
                          height: 10,
                        ),
                        makeVitalPickerWidget(title: '맥박'),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              VitalInputModel vitalData = VitalInputModel(
                                inputDate: date.toString(),
                                tempLeft: temperatureLeft,
                                tempRight: temperatureRight,
                                weight: weight,
                                systolic: bloodPressureHigh,
                                diastolic: bloodPressureLow,
                                pulse: pulse,
                              );

                              await vitalViewModel.create(vitalData);

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Successfully saved!')),
                                );
                              }
                            },
                            child: const Text('Save'))
                      ],
                    )
                  : Container(),
              IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    setInitialValue();
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Row makeVitalPickerWidget({required String title}) {
    double defaultValue = 0;
    switch (title) {
      case '체온(좌)':
        defaultValue = temperatureLeft;
        break;
      case '체온(우)':
        defaultValue = temperatureRight;
        break;
      case '체중':
        defaultValue = weight;
        break;
      case '혈압(수축기)':
        defaultValue = bloodPressureHigh;
        break;
      case '혈압(이완기)':
        defaultValue = bloodPressureLow;
        break;
      case '맥박':
        defaultValue = pulse;
        break;
    }

    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 78, 4, 91)),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    switch (title) {
                      case '체온(좌)':
                        temperatureLeft = temperatureLeft - 0.1;
                        break;
                      case '체온(우)':
                        temperatureRight = temperatureRight - 0.1;
                        break;
                      case '체중':
                        weight = weight - 0.1;
                        break;
                      case '혈압(수축기)':
                        bloodPressureHigh--;
                        break;
                      case '혈압(이완기)':
                        bloodPressureLow--;
                        break;
                      case '맥박':
                        pulse--;
                        break;
                    }
                  });
                },
                child: const Text(
                  '-',
                  style: TextStyle(
                    color: Color.fromARGB(255, 78, 4, 91),
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // errorMessage = null;
                  setState(() {
                    containerColor =
                        // Colors.purple.shade100; // Change color on tap
                        const Color.fromARGB(255, 78, 4, 91);
                  });

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('$title 값을 얼마로 설정할까요?'),
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal:
                                    true), // Allow numbers and decimal point
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(
                                  r'^\d+\.?\d{0,2}')), // Allow digits and decimal point, up to two decimal places
                            ],
                            decoration: const InputDecoration(hintText: ' '),
                            autofocus: true,
                            onChanged: (value) {
                              double? parsedValue = double.tryParse(value);
                              if (parsedValue != null) {
                                defaultValue = parsedValue;
                              } else if (value.isEmpty) {
                                errorMessage = '빈 값을 입력할 수 없습니다. 숫자를 입력해 주세요😄';

                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          content: Text(
                                            errorMessage!,
                                            style: const TextStyle(
                                                color: Colors.red),
                                          ),
                                        ));
                              }
                            },
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            errorMessage = null;
                          },
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, defaultValue);
                            errorMessage = null;
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ).then((value) {
                    if (value == null) return;
                    setState(() {
                      switch (title) {
                        case '체온(좌)':
                          temperatureLeft = value;
                          break;
                        case '체온(우)':
                          temperatureRight = value;
                          break;
                        case '체중':
                          weight = value;
                          break;
                        case '혈압(수축기)':
                          bloodPressureHigh = value;
                          break;
                        case '혈압(이완기)':
                          bloodPressureLow = value;
                          break;
                        case '맥박':
                          pulse = value;
                          break;
                      }
                    });
                  });
                },
                child: Container(
                  height: 60,
                  width: 100,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.purple.shade50),
                  child: Text(
                    title.contains('혈압') || title.contains('맥박')
                        ? defaultValue.toStringAsFixed(0)
                        : defaultValue.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    switch (title) {
                      case '체온(좌)':
                        temperatureLeft = temperatureLeft + 0.1;
                        break;
                      case '체온(우)':
                        temperatureRight = temperatureRight + 0.1;
                        break;
                      case '체중':
                        weight = weight + 0.1;
                        break;
                      case '혈압(수축기)':
                        bloodPressureHigh++;
                        break;
                      case '혈압(이완기)':
                        bloodPressureLow++;
                        break;
                      case '맥박':
                        pulse++;
                        break;
                    }
                  });
                },
                child: Text(
                  '+',
                  style: plusMinusStyle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
