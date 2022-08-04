import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:stadistic/src/data_controller.dart';

class OgiveDialog {
  DataController controller = DataController();
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
      height: size.height,
      width: size.width,
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
      child: _ogive(size),
    );
  }

  Widget _ogive(Size size) {
    List<double> axisX = [];
    List<double> axisY = [];
    if (controller.isDiscrete) {
      axisX = controller.dataList.map((e) => e.xi!).toList();
      axisY = controller.ogiveData;
    } else {
      axisX = controller.dataList.map((e) => e.li1!).toList();
      axisX.add(controller.dataList.last.li!);
      axisY = controller.ogiveData;
      axisY.add(100);
    }

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
      height: size.height,
      width: size.width,
      child: SfCartesianChart(
        series: <ChartSeries>[
          SplineSeries<ChartData, double>(
              markerSettings: const MarkerSettings(
                  isVisible: true,
                  shape: DataMarkerType.circle,
                  color: Colors.white),
              dataSource: data,
              yValueMapper: (data, _) => data.y,
              xValueMapper: (data, _) => data.x,
              pointColorMapper: (data, _) => data.color,
              dataLabelMapper: (data, _) =>
                  '${data.x.toStringAsFixed(2)}, ${data.x.toStringAsFixed(2)}',
              dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  borderColor: Colors.black,
                  borderWidth: size.aspectRatio,
                  useSeriesColor: true,
                  labelPosition: ChartDataLabelPosition.outside,
                  labelAlignment: ChartDataLabelAlignment.top),
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
