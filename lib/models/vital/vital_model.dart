// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VitalModel {
  int id;
  String date;
  String time;
  double tempLeft;
  double tempRight;
  double weight;
  double systolic;
  double diastolic;
  double pulse;
  String? memo;
  VitalModel({
    required this.id,
    this.date = '',
    this.time = '',
    this.memo,
    required this.tempLeft,
    required this.tempRight,
    required this.weight,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
  });

  factory VitalModel.fromMap(Map<String, dynamic> map) {
    final utc = DateTime.parse(map['input_date']);
    final kst = utc.toLocal().toString();
    // print(map['memo'].length); //runtimeType String
    return VitalModel(
      id: map['id'],
      date: kst.split(' ')[0],
      time: kst.split(' ')[1],
      tempLeft: double.parse(map['temp_left']),
      tempRight: double.parse(map['temp_right']),
      weight: double.parse(map['weight']),
      systolic: map['systolic'].toDouble(),
      diastolic: map['diastolic'].toDouble(),
      pulse: map['pulse'] == null ? 0 : map['pulse'].toDouble(),
      memo: map['memo'],
    );
  }

  factory VitalModel.fromJson(String source) =>
      VitalModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class VitalInputModel {
  String inputDate;
  double tempLeft;
  double tempRight;
  double weight;
  double systolic;
  double diastolic;
  double pulse;
  String? memo;
  VitalInputModel({
    required this.inputDate,
    required this.tempLeft,
    required this.tempRight,
    required this.weight,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    this.memo
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'input_date': inputDate,
      'temp_left': tempLeft,
      'temp_right': tempRight,
      'weight': weight,
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
      'memo' : memo
    };
  }

  String toJson() => json.encode(toMap());
}

class VitalUpdateModel {
  int id;
  String? inputDate;
  double? tempLeft;
  double? tempRight;
  double? weight;
  double? systolic;
  double? diastolic;
  double? pulse;
  String? memo;
  VitalUpdateModel({
    required this.id,
    this.inputDate,
    this.tempLeft,
    this.tempRight,
    this.weight,
    this.systolic,
    this.diastolic,
    this.pulse,
    this.memo,
  });
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'id': id,
    };

    if (inputDate != null) map['input_date'] = inputDate;
    if (tempLeft != null) map['temp_left'] = tempLeft;
    if (tempRight != null) map['temp_right'] = tempRight;
    if (weight != null) map['weight'] = weight;
    if (systolic != null) map['systolic'] = systolic;
    if (diastolic != null) map['diastolic'] = diastolic;
    if (pulse != null) map['pulse'] = pulse;
    if (memo != null) map['memo'] = memo;

    return map;
  }
}


