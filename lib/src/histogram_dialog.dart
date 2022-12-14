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
    List<double> axisY = controller.histogramData;
    List<ChartData> chartData = [];
    chartData.add(ChartData(
      0,
      0,
    ));
    for (int i = 0; i < axisY.length; i++) {
      chartData.add(ChartData(
        controller.dataList[i].li1!,
        axisY[i],
      ));
    }
    chartData.add(ChartData(controller.dataList.last.li!, axisY.last));

    return SizedBox(
      height: size.height * 0.6,
      width: size.width * 0.7,
      child: SfCartesianChart(
        series: <ChartSeries>[
          StepAreaSeries<ChartData, double>(
              dataSource: chartData,
              sortFieldValueMapper: (data, _) => data.x,
              yValueMapper: (data, int i) => data.y,
              xValueMapper: (data, _) => data.x,
              dataLabelMapper: (data, _) =>
                  '${data.x.toStringAsFixed(2)}, ${data.y.toStringAsFixed(2)}',
              dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  useSeriesColor: true,
                  borderColor: Colors.black,
                  borderWidth: size.aspectRatio,
                  labelPosition: ChartDataLabelPosition.outside,
                  labelAlignment: ChartDataLabelAlignment.top),
              borderDrawMode: BorderDrawMode.all,
              borderColor: Colors.black,
              xAxisName: 'Intervalos',
              yAxisName: 'Frecuencias',
              animationDuration: 3500,
              color: barColor,
              borderWidth: 3),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final double y;
  final double x;
}
