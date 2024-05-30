import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vital/utils/custom_scaffold.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  bool isAlarmChecked = false;
  TextStyle medicineStyle =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // title: '복용약',
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _setDefaultMedicineCard(context),
            // ListView.builder(
            //     primary: false,
            //     shrinkWrap: true,
            //     itemCount: 1,
            //     itemBuilder: (BuildContext context, int index) {
            //       return const ListTile(
            //         leading: Icon(
            //           Icons.local_hospital,
            //           color: Colors.red,
            //         ),
            //         // isThreeLine: true,
            //         title: Text('오마코'),
            //         subtitle: Text('오메가3 \n1알'),
            //       );
            //     }),
          ],
        ),
      ),
    );
  }

  _setDefaultMedicineCard(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(children: [
            Card(
              // surfaceTintColor: Colors.transparent,
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '복용중 약',
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
                          const SizedBox(
                            height: 10,
                          ),
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
}
