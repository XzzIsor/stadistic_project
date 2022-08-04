import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:stadistic/src/data_controller.dart';

class CircularDialog {
  DataController controller = DataController();
  Color barColor = Color.fromRGBO(
      Random().nextInt(250), Random().nextInt(250), Random().nextInt(250), 1);

  Future<void> showColumnDialog(BuildContext context) async {
    Size size = MediaQuery.of(context).size;

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: _circularContainer(size),
            elevation: 24,
          );
        });
  }

  Widget _circularContainer(Size size) {
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
      child: _circular(size),
    );
  }

  Widget _circular(Size size) {
    List<double> axisY = controller.histogramData;
    List<ChartData> chartData = [];
    for (int i = 0; i < axisY.length; i++) {
      chartData.add(ChartData(
          controller.dataList[i].xi!,
          axisY[i],
          Color.fromRGBO(Random().nextInt(250), Random().nextInt(250),
              Random().nextInt(250), 1)));
    }

    return SizedBox(
      height: size.height * 0.6,
      width: size.width * 0.7,
      child: SfCircularChart(
        series: <CircularSeries>[
          PieSeries<ChartData, double>(
            dataSource: chartData,
            yValueMapper: (data, int i) => data.y,
            xValueMapper: (data, _) => data.x,
            dataLabelMapper: (data, _) =>
                '${data.y.toStringAsFixed(0)}% - Xi = ${data.x.toStringAsFixed(0)}',
            dataLabelSettings: DataLabelSettings(
                isVisible: true,
                useSeriesColor: true,
                borderColor: Colors.black,
                borderWidth: size.aspectRatio,
                labelPosition: ChartDataLabelPosition.outside,
                labelAlignment: ChartDataLabelAlignment.top),
            animationDuration: 3000,
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final double y;
  final double x;
  final Color color;
}
