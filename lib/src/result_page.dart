import 'package:flutter/material.dart';
import 'package:stadistic/src/histogram_dialog.dart';
import 'package:stadistic/src/ojiva_dialog.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<TableRow> rows = [];

  @override
  Widget build(BuildContext context) {
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
              _tchebycheff(size)
            ],
          ),
        ),
      ),
    );
  }

  Widget _table(Size size) {
    rows.add(_tableRows(size));
    rows.add(_tableRows(size));

    return SizedBox(
        child: Table(
      border: TableBorder.all(color: Colors.black, width: 1),
      children: rows,
    ));
  }

  TableRow _tableRows(Size size) {
    int number = 10;
    return TableRow(children: [
      _row(size, '#', number),
      _row(size, 'Li-1', number),
      _row(size, 'Li', number),
      _row(size, 'xi', number),
      _row(size, 'ni', number),
      _row(size, 'fi', number),
      _row(size, 'Ni', number),
      _row(size, 'Fi', number),
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
              Text('Media:    85',
                  style: TextStyle(
                      fontSize: size.aspectRatio * 10, color: Colors.black)),
              Text('Mediana:    25',
                  style: TextStyle(
                      fontSize: size.aspectRatio * 10, color: Colors.black)),
              Text('Moda:    35',
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
              Text('Varianza:    85',
                  style: TextStyle(
                      fontSize: size.aspectRatio * 10, color: Colors.black)),
              SizedBox(
                width: size.width * 0.15,
              ),
              Text('Desviación Estándar:    25',
                  style: TextStyle(
                      fontSize: size.aspectRatio * 10, color: Colors.black)),
              SizedBox(
                width: size.width * 0.11,
              ),
              Text('Coeficiente de Variación:    35',
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
            OjivaDialog().showOjivaDialog(context);
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
                  onPressed: () {},
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
            )
          ],
        ),
      ),
    );
  }
}