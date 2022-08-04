import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stadistic/src/data_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FrecuencyDialog {
  DataController controller = DataController();
  Color barColor = Color.fromRGBO(
      Random().nextInt(250), Random().nextInt(250), Random().nextInt(250), 1);
  Future<void> showFrecuencyDialog(BuildContext context) async {
    Size size = MediaQuery.of(context).size;

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: _frecuencyContainer(size),
            elevation: 24,
          );
        });
  }

  Widget _frecuencyContainer(Size size) {
    return Container(
      height: size.height * 0.85,
      width: size.width * 0.85,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: size.aspectRatio * 6,
            spreadRadius: size.aspectRatio * 2,
          ),
        ],
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: _frecuency(size),
    );
  }

  Widget _frecuency(Size size) {
    List<double> axisX = controller.dataList.map((e) => e.li1!).toList();
    axisX.add(controller.dataList.last.li!);
    List<double> axisY = controller.frecuencyData;
    axisY.add(0);
    List<ChartData> data = [];
    data.add(ChartData(
        0,
        0,
        Color.fromRGBO(Random().nextInt(250), Random().nextInt(250),
            Random().nextInt(250), 1)));
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
          LineSeries<ChartData, double>(
              markerSettings: const MarkerSettings(
                  isVisible: true,
                  shape: DataMarkerType.circle,
                  color: Colors.white),
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
