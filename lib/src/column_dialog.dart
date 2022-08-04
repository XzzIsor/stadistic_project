import 'dart:math';
import 'package:flutter/material.dart';
import 'package:stadistic/src/data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:stadistic/src/data_controller.dart';

class ColumnDialog {
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
            content: _columnContainer(size),
            elevation: 24,
          );
        });
  }

  Widget _columnContainer(Size size) {
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
      child: _column(size),
    );
  }

  Widget _column(Size size) {
    List<Data> axis = controller.dataList;
    List<ChartData> chartData = [];
    for (int i = 0; i < axis.length; i++) {
      chartData.add(ChartData(
          axis[i].xi!,
          axis[i].ni,
          Color.fromRGBO(Random().nextInt(250), Random().nextInt(250),
              Random().nextInt(250), 1)));
    }

    return SizedBox(
      height: size.height * 0.6,
      width: size.width * 0.7,
      child: SfCartesianChart(
        series: <ChartSeries>[
          ColumnSeries<ChartData, double>(
              dataSource: chartData,
              sortFieldValueMapper: (data, _) => data.x,
              yValueMapper: (data, int i) => data.y,
              xValueMapper: (data, _) => data.x,
              pointColorMapper: (data, _) => data.color,
              dataLabelMapper: (data, _) =>
                  '${data.x.toStringAsFixed(2)}, ${data.y.toStringAsFixed(2)}',
              dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  useSeriesColor: true,
                  borderColor: Colors.black,
                  borderWidth: size.aspectRatio,
                  labelPosition: ChartDataLabelPosition.outside,
                  labelAlignment: ChartDataLabelAlignment.top),
              borderColor: Colors.black,
              xAxisName: 'Intervalos',
              yAxisName: 'Frecuencias',
              animationDuration: 3000,
              color: barColor,
              borderWidth: 3),
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
