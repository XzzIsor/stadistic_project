import 'package:flutter/material.dart';

import 'data_controller.dart';

class CValuesDialog {
  Future<void> showCValuesDialog(BuildContext context) async {
    Size size = MediaQuery.of(context).size;

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            backgroundColor: Colors.transparent,
            content: ValuesContainer(),
            elevation: 24,
          );
        });
  }
}

class ValuesContainer extends StatefulWidget {
  const ValuesContainer({Key? key}) : super(key: key);

  @override
  State<ValuesContainer> createState() => _ValuesContainerState();
}

class _ValuesContainerState extends State<ValuesContainer> {
  DataController controller = DataController();

  String cValues = '';
  String message = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.all(size.aspectRatio * 15),
        height: size.height * 0.45,
        width: size.width * 0.45,
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
                Color.fromARGB(255, 152, 214, 223),
                Color.fromARGB(255, 38, 159, 175),
              ],
              begin: FractionalOffset(0, 0),
              end: FractionalOffset(0.6, 0.4),
            )),
        child: Column(
          children: [
            _dataTextField(size),
            SizedBox(
              height: size.height * 0.02,
            ),
            _button(size, context),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text(message,
                style: TextStyle(
                    color: const Color.fromARGB(255, 155, 26, 17),
                    fontSize: size.aspectRatio * 8)),
          ],
        ));
  }

  Widget _dataTextField(Size size) {
    return Column(
      children: [
        Text('Ingrese las ${controller.m} amplitudes:',
            style: TextStyle(
                color: Colors.black, fontSize: size.aspectRatio * 10)),
        SizedBox(
          height: size.height * 0.02,
        ),
        SizedBox(
            width: size.width * 0.5,
            child: TextField(
              onChanged: ((value) {
                cValues = value;
              }),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 1.0)),
                label: Text('Amplitudes',
                    style: TextStyle(
                        color: Colors.black, fontSize: size.aspectRatio * 10)),
                counterText: 'Ingrese los datos separados por comas',
                hintText: 'Ej: 1,2,3,4,5',
                counterStyle: TextStyle(fontSize: size.aspectRatio * 8),
              ),
            )),
      ],
    );
  }

  Widget _button(Size size, BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          List<String> num = cValues.split(',');
          if (num.length != controller.m) {
            setState(() {
              message = 'Se deben ingresar ${controller.m} amplitudes';
            });
          } else {
            try {
              controller.cValuesString = cValues;
              controller.makeDataForDifferentCValues();
              Navigator.pushNamed(context, '/result');
            } catch (e) {
              setState(() {
                message = 'No ingresar letras. Deben estar separados por comas';
              });
            }
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
              TextStyle(color: Colors.white, fontSize: size.aspectRatio * 12),
        ));
  }
}
