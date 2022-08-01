import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:stadistic/src/data_controller.dart';

class HistogramDialog {
  DataController controller = DataController();
  Color barColor = Color.fromRGBO(
      Random().nextInt(250), Random().nextInt(250), Random().nextInt(250), 1);

  Future<void> showHistogramDialog(BuildContext context) async {
    Size size = MediaQuery.of(context).size;

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: _histogramContainer(size),
            elevation: 24,
          );
        });
  }

  Widget _histogramContainer(Size size) {
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
        color: const Color.fromARGB(255, 152, 214, 223),
      ),
      child: _histogram(size),
    );
  }

  Widget _histogram(Size size) {
    List<double> data = controller.data;
    List<ChartData> chartData = [];
    for (int i = 0; i < data.length; i++) {
      chartData.add(ChartData(
          data[i],
          Color.fromRGBO(Random().nextInt(250), Random().nextInt(250),
              Random().nextInt(250), 1)));
    }

    return SizedBox(
      height: size.height * 0.6,
      width: size.width * 0.7,
      child: SfCartesianChart(
        series: <ChartSeries>[
          HistogramSeries<ChartData, double>(
              dataSource: chartData,
              yValueMapper: (data, int i) => data.y,
              borderColor: Colors.black,
              xAxisName: 'Intervalos',
              yAxisName: 'Frecuencias',
              pointColorMapper: (data, int i) => data.color,
              animationDuration: 4000,
              showNormalDistributionCurve: true,
              curveColor: const Color.fromRGBO(0, 0, 0, 1),
              borderWidth: 3),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.y, this.color);
  final double y;
  final Color color;
}
