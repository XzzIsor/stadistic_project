import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stadistic/src/circular_dialog.dart';
import 'package:stadistic/src/column_dialog.dart';

import 'package:stadistic/src/data.dart';
import 'package:stadistic/src/data_controller.dart';
import 'package:stadistic/src/frecuency_dialog.dart';
import 'package:stadistic/src/histogram_dialog.dart';
import 'package:stadistic/src/ogive_dialog.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  DataController controller = DataController();
  List<TableRow> rows = [];
  List<Data> dataRows = [];
  String messageTcheResult = '';
  String messageTche1 = '';
  String messageTche2 = '';
  String messageTche3 = '';
  @override
  void initState() {
    dataRows = controller.dataList;
    super.initState();
  }

  @override
  void dispose() {
    dataRows.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    rows.clear();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 38, 159, 175),
        title: Center(
            child: Text(
          'Resultados',
          style: TextStyle(fontSize: size.aspectRatio * 16),
        )),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(size.aspectRatio * 15),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: size.aspectRatio * 6,
                  spreadRadius: size.aspectRatio * 2,
                ),
              ],
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 38, 159, 175),
                  Color.fromARGB(255, 152, 214, 223),
                ],
                begin: FractionalOffset(0, 0),
                end: FractionalOffset(0.6, 0.4),
              )),
          height: size.height * 0.85,
          width: size.width * 0.9,
          child: ListView(
            children: [
              Center(
                child: Text(
                  'Tabla de Distribuci??n de Frecuencias',
                  style: TextStyle(
                      color: Colors.black, fontSize: size.aspectRatio * 12),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              _table(size),
              SizedBox(
                height: size.height * 0.05,
              ),
              _rowInfo(size),
              SizedBox(
                height: size.height * 0.03,
              ),
              controller.isDiscrete
                  ? _buttonsRowDiscrete(size)
                  : _buttonsRow(size),
              SizedBox(
                height: size.height * 0.07,
              ),
              controller.isDiscrete ? Container() : _tchebycheff(size)
            ],
          ),
        ),
      ),
    );
  }

  Widget _table(Size size) {
    rows.add(_tableTitleRow(size));
    for (int i = 0; i < dataRows.length; i++) {
      rows.add(_tableRows(size, dataRows[i], i + 1));
    }

    return SizedBox(
        child: Table(
      border: TableBorder.all(color: Colors.black, width: 1),
      children: rows,
    ));
  }

  TableRow _tableTitleRow(Size size) {
    int number = 10;
    return !controller.isDiscrete
        ? TableRow(children: [
            _row(size, '#', number),
            _row(size, 'Li-1', number),
            _row(size, 'Li', number),
            _row(size, 'xi', number),
            _row(size, 'ci', number),
            _row(size, 'ni', number),
            _row(size, 'fi', number),
            _row(size, 'Ni', number),
            _row(size, 'Fi', number),
          ])
        : TableRow(children: [
            _row(size, '#', number),
            _row(size, 'Xi', number),
            _row(size, 'ni', number),
            _row(size, 'fi', number),
            _row(size, 'Ni', number),
            _row(size, 'Fi', number),
          ]);
  }

  TableRow _tableRows(Size size, Data data, int index) {
    int number = 10;
    return !controller.isDiscrete
        ? TableRow(children: [
            _row(size, '$index', number),
            _row(size, data.li1!.toStringAsFixed(2), number),
            _row(size, data.li!.toStringAsFixed(2), number),
            _row(size, data.xi!.toStringAsFixed(2), number),
            _row(size, data.ci.toStringAsFixed(2), number),
            _row(size, data.ni.toStringAsFixed(2), number),
            _row(size, data.fi.toStringAsFixed(2), number),
            _row(size, data.Ni!.toStringAsFixed(2), number),
            _row(size, data.Fi!.toStringAsFixed(2), number),
          ])
        : TableRow(children: [
            _row(size, '$index', number),
            _row(size, data.li!.toStringAsFixed(2), number),
            _row(size, data.ni.toStringAsFixed(2), number),
            _row(size, data.fi.toStringAsFixed(2), number),
            _row(size, data.Ni!.toStringAsFixed(2), number),
            _row(size, data.Fi!.toStringAsFixed(2), number)
          ]);
  }

  Widget _row(Size size, String message, int fontSize) {
    return Container(
      padding: EdgeInsets.only(top: size.height * 0.003),
      height: size.height * 0.03,
      color: Colors.white,
      child: Text(
        message,
        style: TextStyle(fontSize: size.aspectRatio * fontSize),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _columnInfo1(Size size) {
    return SizedBox(
      child: Column(
        children: [
          Text('Indicadores de Tendencia Central',
              style: TextStyle(
                  fontSize: size.aspectRatio * 12, color: Colors.black)),
          SizedBox(
            height: size.height * 0.02,
          ),
          Column(
            children: [
              Text('Media:    ${controller.aritmeticMean.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: size.aspectRatio * 10, color: Colors.black)),
              Text('Mediana:    ${controller.median.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: size.aspectRatio * 10, color: Colors.black)),
              Text('Moda:    ${controller.trend.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: size.aspectRatio * 10, color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _columnInfo2(Size size) {
    return SizedBox(
      child: Column(
        children: [
          Text('Indicadores de Dispersi??n',
              style: TextStyle(
                  fontSize: size.aspectRatio * 12, color: Colors.black)),
          SizedBox(
            height: size.height * 0.02,
          ),
          Column(
            children: [
              Text('Varianza:    ${controller.variance.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: size.aspectRatio * 10, color: Colors.black)),
              Text(
                  'Desviaci??n Est??ndar:    ${controller.standardDeviation.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: size.aspectRatio * 10, color: Colors.black)),
              Text(
                  'Coeficiente de Variaci??n:    ${controller.coefficientOfVariation.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: size.aspectRatio * 10, color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rowInfo(Size size) {
    return SizedBox(
      height: size.height * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _columnInfo1(size),
          _columnInfo2(size),
        ],
      ),
    );
  }

  Widget _dialogButton(Size size, String message, VoidCallback function) {
    return ElevatedButton(
        onPressed: function,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(size.aspectRatio * 12),
          elevation: size.aspectRatio * 5,
          primary: const Color.fromARGB(255, 38, 159, 175),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          message,
          style:
              TextStyle(color: Colors.white, fontSize: size.aspectRatio * 12),
        ));
  }

  Widget _buttonsRow(Size size) {
    return Center(
        child: SizedBox(
      width: size.width * 0.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _dialogButton(size, 'Histograma', () {
            HistogramDialog().showHistogramDialog(context);
          }),
          _dialogButton(size, 'Ojiva', () {
            OgiveDialog().showOgiveDialog(context);
          }),
          _dialogButton(size, 'Poligono Frecuencias', () {
            FrecuencyDialog().showFrecuencyDialog(context);
          }),
        ],
      ),
    ));
  }

  Widget _buttonsRowDiscrete(Size size) {
    return Center(
        child: SizedBox(
      width: size.width * 0.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _dialogButton(size, 'Barras', () {
            ColumnDialog().showColumnDialog(context);
          }),
          _dialogButton(size, 'Circular', () {
            CircularDialog().showColumnDialog(context);
          }),
        ],
      ),
    ));
  }

  Widget _tchebycheff(Size size) {
    String kValue = '0';
    return Center(
      child: SizedBox(
        height: size.height * 0.35,
        child: Column(
          children: [
            Text('Principio de Tchebycheff',
                style: TextStyle(
                    fontSize: size.aspectRatio * 12, color: Colors.black)),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Ingrese el n??mero k: ',
                    style: TextStyle(
                        fontSize: size.aspectRatio * 10, color: Colors.black)),
                SizedBox(
                  width: size.width * 0.004,
                ),
                SizedBox(
                  width: size.width * 0.05,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      kValue = value;
                    },
                    decoration: InputDecoration(
                      label: const Text('Valor k',
                          style: TextStyle(color: Colors.black)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1)),
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.03,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      int divisor = int.parse(kValue) * int.parse(kValue);
                      double result = 1 - (1 / divisor);
                      double response =
                          controller.getTchebycheff(int.parse(kValue));
                      messageTche3 = 'Traza';
                      messageTche1 =
                          'P8(${controller.tcheInterval1.toStringAsFixed(2)}) =< X =< P(${controller.tcheInterval2.toStringAsFixed(2)})';
                      messageTche2 =
                          '${controller.tcheValue2.toStringAsFixed(3)} - ${controller.tcheValue1.toStringAsFixed(3)} >= ${result.toStringAsFixed(2)}';
                      messageTcheResult =
                          'El resultado es: ${response.toStringAsFixed(2)} >= ${result.toStringAsFixed(2)}';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(size.aspectRatio * 9),
                    elevation: size.aspectRatio * 5,
                    primary: const Color.fromARGB(255, 38, 159, 175),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text('Calcular',
                      style: TextStyle(
                          fontSize: size.aspectRatio * 10,
                          color: Colors.white)),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Center(
              child: Text(messageTche3,
                  style: TextStyle(
                      fontSize: size.aspectRatio * 10, color: Colors.black)),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Center(
              child: Text(messageTche1,
                  style: TextStyle(
                      fontSize: size.aspectRatio * 10, color: Colors.black)),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Center(
              child: Text(messageTche2,
                  style: TextStyle(
                      fontSize: size.aspectRatio * 10, color: Colors.black)),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Center(
              child: Text(messageTcheResult,
                  style: TextStyle(
                      fontSize: size.aspectRatio * 10, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
