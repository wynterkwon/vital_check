import 'package:flutter/material.dart';
import 'package:vital/models/vital/vital_model.dart';
import 'package:vital/screens/vital_detail_screen.dart';
import 'package:vital/utils/custom_scaffold.dart';
import 'package:vital/viewmodels/vital_viewmodel.dart';

class VitalListScreen extends StatefulWidget {
  const VitalListScreen({super.key});

  @override
  State<VitalListScreen> createState() => _VitalListScreenState();
}

class _VitalListScreenState extends State<VitalListScreen> {
  VitalViewModel vitalViewModel = VitalViewModel();
  List<VitalModel> resources = [];
  double bloodPulse = 0;
  TextStyle datetimeStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  TextStyle itemStyle = const TextStyle(
    fontSize: 16,
    // color: bloodPulse > 40 ? Colors.red : Colors.
    // fontWeight: FontWeight.bold,
  );
  TextStyle anomalyStyle = const TextStyle(
    fontSize: 16,
    color: Colors.red,
  );

  final ScrollController _scrollController = ScrollController();
  // List<dynamic> _items = [];
  int _currentPage = 1;
  final int _limit = 20;
  bool _isLoading = false;
  bool _hasMoreData = true;

  // bool compareToDefault(String title, double value) {
  //   // final toCompare = (value - item) > 0 ? true : false;
  //   bool isAnomaly = false;
  //   switch (title) {
  //     case '체온(좌)':
  //       value > 37.5 ? isAnomaly = true : isAnomaly = false;
  //       break;
  //     case '체온(우)':
  //       value > 37.5 ? isAnomaly = true : isAnomaly = false;
  //       break;
  //     case '체중':
  //       value > 56.5 ? isAnomaly = true : isAnomaly = false;
  //       break;
  //     case '맥압':
  //       value > 40 ? isAnomaly = true : isAnomaly = false;
  //       break;
  //   }
  //   return isAnomaly;
  // }

  @override
  void initState() {
    super.initState();
    _fetchItems();
    // vitalViewModel.getVitalResource(page: _currentPage, limit: _limit);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchItems();
      }
    });
  }

  Future<void> _fetchItems() async {
    try {
      if (_isLoading || !_hasMoreData) return;

      setState(() {
        _isLoading = true;
      });

      List<VitalModel> response = await vitalViewModel.getVitalResource(
          page: _currentPage, limit: _limit);

      if (response.isNotEmpty) {
        List<VitalModel> fetchedItems = response;

        setState(() {
          _currentPage++;
          _isLoading = false;
          if (fetchedItems.length <= _limit) {
            _hasMoreData = false;
          }
          resources.addAll(fetchedItems);
        });
      } else {
        // Handle error
        setState(() {
          _isLoading = false;
        });
      }
    } catch (err) {
      AlertDialog(content: Text('Something is wrong $err'));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: resources.length,
                  itemBuilder: (BuildContext context, int index) {
                    bloodPulse =
                        resources[index].systolic - resources[index].diastolic;
                    bool hasMemo =
                        (resources[index].memo != null) ? true : false;
                    return _buildDismissibleVitalList(index, context, hasMemo);
                  },
                )),
    );
  }

  Dismissible _buildDismissibleVitalList(
      int index, BuildContext context, bool hasMemo) {
    return Dismissible(
      key: Key(resources[index].toString()),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          setState(() {
            resources.removeAt(index);
          });
        }
      },
      background: _dismissibleBackground(),
      secondaryBackground: _dismissibleSecondaryBackground(),
      confirmDismiss: (direction) {
        if (direction == DismissDirection.endToStart) {
          return showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text('삭제 확인'),
                  content: Text('${resources[index].date} 데이터를 삭제합니다'),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        return Navigator.of(context).pop(false);
                      },
                      child: const Text('취소'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        vitalViewModel.deleteVitalById(resources[index].id);
                        return Navigator.of(context).pop(true);
                      },
                      child: const Text('확인'),
                    ),
                  ],
                );
              });
        } else if (direction == DismissDirection.startToEnd) {
          return showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text('데이터 유지 확인'),
                  content: Text('${resources[index].date} 데이터를 유지합니다'),
                  actions: <Widget>[
                    // ElevatedButton(
                    //   onPressed: () {
                    //     return Navigator.of(context).pop(false);
                    //   },
                    //   child: const Text('CANCEL'),
                    // ),
                    ElevatedButton(
                      onPressed: () {
                        return Navigator.of(context).pop(false);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              });
        }
        return Future.value(false);
      },
      child: Stack(children: [
        Card(
          margin: const EdgeInsets.all(5),
          elevation: 5,
          child: Material(
            color: Colors.transparent,
            child: ListTile(
              onTap: () {
                // Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        VitalDetailScreen(id: resources[index].id),
                    fullscreenDialog: true,
                  ),
                );
              },
              selectedTileColor: Colors.red,
              leading: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    resources[index].date,
                    style: datetimeStyle,
                  ),
                  Text(
                    resources[index].time.substring(0, 5),
                    style: datetimeStyle,
                  ),
                ],
              ),
              // title: Text('title'),
              subtitle: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '체온(좌) ${resources[index].tempLeft.toString()}',
                        style: itemStyle,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '체온(우) ${resources[index].tempRight.toString()}',
                        style: itemStyle,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '체중 ${resources[index].weight.toString()}',
                        style: itemStyle,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        '맥박 ${resources[index].pulse.toStringAsFixed(0)}',
                        style: itemStyle,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '혈압 ${resources[index].systolic.toStringAsFixed(0)} / ',
                        style: resources[index].systolic > 135
                            ? anomalyStyle
                            : itemStyle,
                      ),
                      Text(
                        '${resources[index].diastolic.toStringAsFixed(0)}  ',
                        style: resources[index].diastolic > 95
                            ? anomalyStyle
                            : itemStyle,
                      ),
                      Text(
                        '맥압 ${bloodPulse.toStringAsFixed(0)}',
                        style: bloodPulse > 40 ? anomalyStyle : itemStyle,
                      )
                    ],
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          ),
        ),
        hasMemo
            ? const Positioned(
                left: 22,
                bottom: 18,
                child: Icon(
                  Icons.comment,
                  size: 15,
                ),
              )
            : const SizedBox.shrink()
      ]),
    );
  }

  Container _dismissibleSecondaryBackground() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.red,
      alignment: Alignment.centerRight,
      child: const Icon(
        Icons.delete,
        size: 36,
        color: Colors.white,
      ),
    );
  }

  Container _dismissibleBackground() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.green,
      alignment: Alignment.centerLeft,
      child: const Icon(
        Icons.save,
        size: 36,
        color: Colors.white,
      ),
    );
  }
}
