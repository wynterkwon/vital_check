import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  final Widget body;
  final List<Widget> actions;
  final Widget? leading;
  final String? title;

  const MyScaffold(
      {super.key,
      required this.body,
      this.actions = const [],
      this.leading,
      this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions: actions,
        leading: leading,
        title: title != null ? Text(title!) : null,
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // Color.fromARGB(255, 36, 1, 43),
                  Color.fromARGB(255, 245, 241, 244),
                  // Color(0xff1f2123),
                  Color.fromARGB(255, 243, 156, 240),
                  // Color.fromARGB(255, 109, 233, 132),
                  Color.fromARGB(255, 245, 241, 244),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: body,
          ),
        ],
      ),
    );
  }
}
