// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:vital/screens/setting_screen.dart';

import 'package:vital/utils/custom_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: SafeArea(
        child: context.orientation == Orientation.portrait
            ? _buildHomeScreen()
            : SingleChildScrollView(child: _buildHomeScreen()),
      ),
    );
  }

  Column _buildHomeScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HomeMenuButton(
          title: 'Vital 차트 보기',
          path: '/graph',
        ),
        const SizedBox(
          height: 20,
        ),
        HomeMenuButton(
          title: 'Vital 목록 보기',
          path: '/list',
        ),
        const SizedBox(
          height: 20,
        ),
        HomeMenuButton(
          title: '오늘의 Vital 기록',
          path: '/add',
        ),
        const SizedBox(
          height: 20,
        ),
        // HomeMenuButton(
        //   title: 'Vital 업데이트',
        //   path: '/update',
        // ),
        // const SizedBox(
        //   height: 20,
        // ),
        HomeMenuButton(
          title: '복용중 약',
          path: '/medicine',
        ),
        const SizedBox(
          height: 20,
        ),
        HomeMenuButton(
          title: '⚙️ 설정',
          path: '/setting',
        ),
        // ElevatedButton(
        //     onPressed: () {
        //       Get.to(const SettingScreen());
        //     },
        //     child: const Text('GetX')),
      ],
    );
  }
}

class HomeMenuButton extends StatelessWidget {
  String title;
  String path;
  HomeMenuButton({super.key, required this.title, required this.path});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, path);
      },
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          fixedSize: const Size(200, 50),
          textStyle:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      child: Text(title),
    );
  }
}
