import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:vital/models/vital/vital_model.dart';
import 'package:vital/constants/app_colors.dart';
import 'package:vital/utils/custom_scaffold.dart';
import 'package:vital/viewmodels/vital_viewmodel.dart';

class VitalDetailScreen extends StatefulWidget {
  final int id;
  const VitalDetailScreen({super.key, required this.id});

  @override
  State<VitalDetailScreen> createState() => _VitalDetailScreenState();
}

class _VitalDetailScreenState extends State<VitalDetailScreen> {
  VitalViewModel vitalViewModel = VitalViewModel();
  late Future<VitalModel> initialVital;
  late String date;
  late String time;
  late double temperatureLeft;
  late double temperatureRight;
  late double bloodPressureHigh;
  late double bloodPressureLow;
  late double weight;
  late double pulse;
  late String? memo;
  DateTime updatedDate = DateTime.now();
  Color containerColor = Colors.purple.shade50;
  String? errorMessage;
  TextStyle plusMinusStyle = const TextStyle(
    color: Color.fromARGB(255, 78, 4, 91),
    fontSize: 30,
    fontWeight: FontWeight.w900,
  );
  bool isMemoClicked = false;
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Future<VitalModel> fetchInitialData() async {
    final vital = await vitalViewModel.getOneVitalById(widget.id);
    date = vital.date;
    time = vital.time.substring(0, 5);
    temperatureLeft = vital.tempLeft;
    temperatureRight = vital.tempRight;
    bloodPressureHigh = vital.systolic;
    bloodPressureLow = vital.diastolic;
    weight = vital.weight;
    pulse = vital.pulse;
    memo = vital.memo;

    return vital;
  }

  @override
  void initState() {
    initialVital = fetchInitialData();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: FutureBuilder(
          future: initialVital,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              VitalModel vital = snapshot.data!;
              _textEditingController.text =
                  vital.memo != null ? vital.memo! : '';

              return SafeArea(
                child: GestureDetector(
                  onTap: () {
                    _focusNode.unfocus();
                  },
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          _showDate(context, vital),
                          _showTime(context, vital),
                          const SizedBox(
                            height: 10,
                          ),
                          // _buildMedicineRow(),
                          const SizedBox(
                            height: 5,
                          ),
                          _buildMemoRow(vital, context),
                          const SizedBox(
                            height: 10,
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Container(
                          //     padding: const EdgeInsets.all(10),
                          //     width: MediaQuery.of(context).size.width,
                          //     decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(10),
                          //         color: Colors.grey.withOpacity(0.2)),
                          //     child: Stack(children: [
                          //       vital.memo!.isNotEmpty
                          //           ? Text('메모 ${vital.memo!}')
                          //           : const TextField(),
                          //     ]),
                          //   ),
                          // ),
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
                          // ElevatedButton(
                          //     onPressed: () async {
                          //       VitalInputModel vitalData = VitalInputModel(
                          //         inputDate: updatedDate.toString(),
                          //         tempLeft: temperatureLeft,
                          //         tempRight: temperatureRight,
                          //         weight: weight,
                          //         systolic: bloodPressureHigh,
                          //         diastolic: bloodPressureLow,
                          //         pulse: pulse,
                          //       );
                          //       print(date);
                          //       print(time);
                          //       String newDateTime = '$date $time';
                          //       DateTime parsedDateTime =
                          //           DateTime.parse(newDateTime);
                          //       print(parsedDateTime.toString());
                          //       // await vitalViewModel.create(vitalData);

                          //       if (context.mounted) {
                          //         ScaffoldMessenger.of(context).showSnackBar(
                          //           const SnackBar(
                          //               content: Text('Successfully saved!')),
                          //         );
                          //       }
                          //     },
                          //     child: const Text('Save')),
                          ElevatedButton(
                            onPressed: () async {
                              VitalUpdateModel newVitalData = VitalUpdateModel(
                                id: widget.id,
                                inputDate: '${date}T$time',
                                tempLeft: temperatureLeft,
                                tempRight: temperatureRight,
                                weight: weight,
                                systolic: bloodPressureHigh,
                                diastolic: bloodPressureLow,
                                pulse: pulse,
                                memo: _textEditingController.text,
                              );
                              print(widget.id);
                              print('${date}T$time');
                              print(newVitalData);
                              // DateTime.parse('${date}T${time}');
                              await vitalViewModel.updateVital(newVitalData);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Successfully updated!')),
                                );
                              }
                            },
                            child: const Text('Update'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return AlertDialog(
                content:
                    Text('Something went wrong ${snapshot.error.toString()}'),
              );
            }
          }),
    );
  }

  Container _buildMedicineRow() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.withAlpha(50),
          // color: Colors.transparent,
          borderRadius: BorderRadius.circular(10)),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                '  💊',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(flex: 5, child: Text('start   '))
          ],
        ),
      ),
    );
  }

  Row _buildMemoRow(VitalModel vital, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        vital.memo != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.comment,
                    color: AppColors.primaryDark,
                    size: 15,
                    // Colors.grey.shade700,
                  ),
                  Text(' ${vital.memo}'),
                ],
              )
            : Expanded(
                child: TextField(
                  maxLength: 256,
                  focusNode: _focusNode,
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    border: _focusNode.hasFocus
                        ? const OutlineInputBorder()
                        : InputBorder.none,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.comment,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        TextButton(
                            onPressed: () {}, child: const Text('Memo 추가')),
                      ],
                    ),
                    suffix: IconButton(
                        onPressed: () {
                          _textEditingController.text = '';
                        },
                        icon: const Icon(Icons.close)),
                  ),
                ),
              )
      ],
    );
  }

  SizedBox _showDate(BuildContext context, VitalModel vital) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                date,
                style: const TextStyle(
                  color: Color.fromARGB(255, 78, 4, 91),
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          Positioned(
            right: 20,
            top: 10,
            child: InkWell(
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.parse(vital.date),
                  firstDate: DateTime(2014),
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  setState(() {
                    // updatedDate = selectedDate;
                    date = selectedDate.toString().split(' ')[0];
                    // date= selectedDate;
                    // setInitialValue();
                  });
                }
              },
              child: const Icon(
                Icons.calendar_month,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _showTime(BuildContext context, VitalModel vital) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                time,
                style: const TextStyle(
                  color: Color.fromARGB(255, 78, 4, 91),
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          Positioned(
            right: 20,
            top: 10,
            child: InkWell(
              onTap: () async {
                final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 6, minute: 30));
                if (selectedTime != null) {
                  setState(() {
                    print(selectedTime.toString());
                    time =
                        '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                  });
                }
              },
              child: const Icon(
                Icons.alarm,
                color: AppColors.primaryDark,
                size: 28,
              ),
            ),
          )
        ],
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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
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
