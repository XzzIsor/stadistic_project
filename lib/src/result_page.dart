import 'dart:math';

import 'package:flutter/material.dart';

import 'package:stadistic/src/data.dart';
import 'package:stadistic/src/data_controller.dart';
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
  String messageTche = '';
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
          style: TextStyle(fontSize: size.aspectRatio * 13),
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
            color: const Color.fromARGB(255, 152, 214, 223),
          ),
          height: size.height * 0.85,
          width: size.width * 0.9,
          child: ListView(
            children: [
              Center(
                child: Text(
                  'Tabla de Distribución de Frecuencias',
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
              _rowInfo1(size),
              SizedBox(
                height: size.height * 0.06,
              ),
              _rowInfo2(size),
              SizedBox(
                height: size.height * 0.09,
              ),
              _buttonsRow(size),
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

  Widget _rowInfo1(Size size) {
    return SizedBox(
      width: size.width * 0.7,
      child: Column(
        children: [
          Text('Indicadores de Tendencia Central',
              style: TextStyle(
                  fontSize: size.aspectRatio * 12, color: Colors.black)),
          SizedBox(
            height: size.height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

  Widget _rowInfo2(Size size) {
    return SizedBox(
      width: size.width * 0.7,
      child: Column(
        children: [
          Text('Indicadores de Dispersión',
              style: TextStyle(
                  fontSize: size.aspectRatio * 12, color: Colors.black)),
          SizedBox(
            height: size.height * 0.02,
          ),
          Row(
            children: [
              SizedBox(
                width: size.width * 0.17,
              ),
              Text('Varianza:    ${controller.variance.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: size.aspectRatio * 10, color: Colors.black)),
              SizedBox(
                width: size.width * 0.15,
              ),
              Text(
                  'Desviación Estándar:    ${controller.standardDeviation.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: size.aspectRatio * 10, color: Colors.black)),
              SizedBox(
                width: size.width * 0.11,
              ),
              Text(
                  'Coeficiente de Variación:    ${controller.coefficientOfVariation.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: size.aspectRatio * 10, color: Colors.black)),
            ],
          ),
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
              TextStyle(color: Colors.white, fontSize: size.aspectRatio * 15),
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
        ],
      ),
    ));
  }

  Widget _tchebycheff(Size size) {
    String kValue = '0';
    return Center(
      child: SizedBox(
        height: size.height * 0.15,
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
                Text('Ingrese el número k: ',
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
                      messageTche =
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
              child: Text(messageTche,
                  style: TextStyle(
                      fontSize: size.aspectRatio * 10, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
