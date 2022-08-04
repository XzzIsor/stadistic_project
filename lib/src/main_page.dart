import 'package:flutter/material.dart';
import 'package:stadistic/src/cvalues_dialog.dart';
import 'package:stadistic/src/data_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isDiscretCheck = true;
  bool isContinuesCheck = false;
  bool cValues = false;
  bool showCheck = false;
  String data = '';
  DataController controller = DataController();
  String errorMessage = '';
  String graphicMessage = 'D. Barras';
  String graphicMessage2 = 'D. Circular';
  String graphicMessage3 = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 38, 159, 175),
        title: Center(
            child: Text(
          'Calculadora Estadistica',
          style: TextStyle(fontSize: size.aspectRatio * 16),
        )),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(size.aspectRatio * 12),
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
              _columnCheckBoxes(size),
              SizedBox(
                height: size.height * 0.03,
              ),
              _dataTextField(size),
              SizedBox(
                height: size.height * 0.01,
              ),
              showCheck ? _cValuesCheckBox(size) : Container(),
              SizedBox(
                height: size.height * 0.02,
              ),
              _infoBox(size),
              SizedBox(
                height: size.height * 0.05,
              ),
              Text(errorMessage,
                  style: TextStyle(
                      color: const Color.fromARGB(255, 175, 20, 9),
                      fontSize: size.aspectRatio * 12)),
              SizedBox(
                height: size.height * 0.02,
              ),
              _button(size)
            ],
          ),
        ),
      ),
    );
  }

  Widget _dataTextField(Size size) {
    return Column(
      children: [
        Text('Ingrese los datos:',
            style: TextStyle(
                color: Colors.black, fontSize: size.aspectRatio * 11)),
        SizedBox(
          height: size.height * 0.02,
        ),
        SizedBox(
            width: size.width * 0.8,
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              onChanged: ((value) {
                setState(() {
                  data = value;
                });
              }),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 1.0)),
                label: Text('Datos',
                    style: TextStyle(
                        color: Colors.black, fontSize: size.aspectRatio * 10)),
                counterText: 'Ingrese los datos separados por comas',
                hintText: 'Ej: 1,2,3,4,5,6',
                counterStyle: TextStyle(fontSize: size.aspectRatio * 8),
              ),
            )),
      ],
    );
  }

  Widget _columnCheckBoxes(Size size) {
    return SizedBox(
      height: size.height * 0.2,
      child: Column(
        children: [
          Text(
            'Seleccione el tipo de datos: ',
            style:
                TextStyle(color: Colors.black, fontSize: size.aspectRatio * 12),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                  value: isDiscretCheck,
                  onChanged: (value) {
                    setState(() {
                      cValues = false;
                      showCheck = false;
                      isDiscretCheck = true;
                      isContinuesCheck = false;
                      graphicMessage = 'D. Barras';
                      graphicMessage2 = 'D. Circular';
                      graphicMessage3 = '';
                    });
                  }),
              SizedBox(width: size.width * 0.005),
              Text(
                'Variables Discretas',
                style: TextStyle(
                    color: Colors.black, fontSize: size.aspectRatio * 10),
              )
            ],
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                  value: isContinuesCheck,
                  onChanged: (value) {
                    setState(() {
                      showCheck = true;
                      isDiscretCheck = false;
                      isContinuesCheck = true;
                      graphicMessage = 'Histograma - P. Frecuencias';
                      graphicMessage2 = 'Ojiva';
                      graphicMessage3 = 'Principio de Tchebycheff';
                    });
                  }),
              SizedBox(width: size.width * 0.005),
              Text(
                'Variables Continuas',
                style: TextStyle(
                    color: Colors.black, fontSize: size.aspectRatio * 10),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _button(Size size) {
    return SizedBox(
      child: ElevatedButton(
          onPressed: () {
            controller.dataString = data;
            controller.isDiscrete = isDiscretCheck;

            if (!cValues) {
              try {
                controller.makeData();
                Navigator.pushNamed(context, '/result');
              } catch (e) {
                setState(() {
                  errorMessage =
                      'Datos erroneos o mal ingresados. Recuerde que deben ingresarse al menos 3 datos no repetidos y separados por comas';
                });
              }
            } else {
              controller.makeData();
              CValuesDialog().showCValuesDialog(context);
            }
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(size.aspectRatio * 12),
            elevation: size.aspectRatio * 5,
            primary: const Color.fromARGB(255, 38, 159, 175),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            'Calcular',
            style:
                TextStyle(color: Colors.white, fontSize: size.aspectRatio * 15),
          )),
    );
  }

  Widget _cValuesCheckBox(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
            activeColor: Colors.green[900],
            value: cValues,
            onChanged: (value) {
              setState(() {
                cValues = !cValues;
              });
            }),
        SizedBox(width: size.width * 0.005),
        Text(
          '¿Ingresar Amplitudes?',
          style: TextStyle(
              color: Colors.green[900], fontSize: size.aspectRatio * 10),
        )
      ],
    );
  }

  Widget _infoBox(Size size) {
    return SizedBox(
      height: size.height * 0.12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Cálculos a Realizar: ',
            style:
                TextStyle(color: Colors.black, fontSize: size.aspectRatio * 12),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    'Media Aritmética',
                    style: TextStyle(
                        color: Colors.black, fontSize: size.aspectRatio * 10),
                  ),
                  Text(
                    'Mediana',
                    style: TextStyle(
                        color: Colors.black, fontSize: size.aspectRatio * 10),
                  ),
                  Text(
                    'Moda',
                    style: TextStyle(
                        color: Colors.black, fontSize: size.aspectRatio * 10),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Varianza',
                    style: TextStyle(
                        color: Colors.black, fontSize: size.aspectRatio * 10),
                  ),
                  Text(
                    'Desviación Estándar',
                    style: TextStyle(
                        color: Colors.black, fontSize: size.aspectRatio * 10),
                  ),
                  Text(
                    'Coeficiente de Variación',
                    style: TextStyle(
                        color: Colors.black, fontSize: size.aspectRatio * 10),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    graphicMessage,
                    style: TextStyle(
                        color: Colors.black, fontSize: size.aspectRatio * 10),
                  ),
                  Text(
                    graphicMessage2,
                    style: TextStyle(
                        color: Colors.black, fontSize: size.aspectRatio * 10),
                  ),
                  Text(
                    graphicMessage3,
                    style: TextStyle(
                        color: Colors.black, fontSize: size.aspectRatio * 10),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
