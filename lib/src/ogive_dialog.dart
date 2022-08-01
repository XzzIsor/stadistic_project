import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:stadistic/src/data_controller.dart';

class OgiveDialog {
  DataController controller = DataController();
  Color barColor = Color.fromRGBO(
      Random().nextInt(250), Random().nextInt(250), Random().nextInt(250), 1);
  Future<void> showOgiveDialog(BuildContext context) async {
    Size size = MediaQuery.of(context).size;

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: _ogiveContainer(size),
            elevation: 24,
          );
        });
  }

  Widget _ogiveContainer(Size size) {
    return Container(
      height: size.height * 0.85,
      width: size.width * 0.9,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: size.aspectRatio * 6,
            spreadRadius: size.aspectRatio * 2,
          ),
        ],
        borderRadius: BorderRadius.circular(25),
        color: const Color.fromARGB(255, 169, 208, 214),
      ),
      child: _ogive(size),
    );
  }

  Widget _ogive(Size size) {
    List<double> axisX = controller.dataList.map((e) => e.li!).toList();
    List<double> axisY = controller.ogiveData;
    List<ChartData> data = [];

    for (int i = 0; i < axisX.length; i++) {
      data.add(ChartData(
          axisY[i],
          axisX[i],
          Color.fromRGBO(Random().nextInt(250), Random().nextInt(250),
              Random().nextInt(250), 1)));
    }

    return SizedBox(
      height: size.height * 0.6,
      width: size.width * 0.7,
      child: SfCartesianChart(
        series: <ChartSeries>[
          SplineSeries<ChartData, double>(
              dataSource: data,
              yValueMapper: (data, _) => data.y,
              xValueMapper: (data, _) => data.x,
              pointColorMapper: (data, _) => data.color,
              xAxisName: 'Intervalos',
              yAxisName: 'Frecuencias',
              animationDuration: 4000,
              width: 4),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.y, this.x, this.color);
  final double x;
  final double y;
  final Color color;
}
