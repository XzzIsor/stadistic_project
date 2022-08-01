import 'package:flutter/material.dart';
import 'package:stadistic/src/data_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isDiscretCheck = true;
  bool isContinuesCheck = false;
  String data = '';
  DataController controller = DataController();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 38, 159, 175),
        title: Center(
            child: Text(
          'Ingresar Datos',
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
          child: Column(
            children: [
              Text(
                'Selecione el tipo de datos',
                style: TextStyle(
                    color: Colors.black, fontSize: size.aspectRatio * 12),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              _rowCheckBoxes(size),
              SizedBox(
                height: size.height * 0.05,
              ),
              _dataTextField(size),
              SizedBox(
                height: size.height * 0.4,
              ),
              Text(errorMessage,
                  style: TextStyle(
                      color: const Color.fromARGB(255, 175, 20, 9),
                      fontSize: size.aspectRatio * 12)),
              SizedBox(
                height: size.height * 0.05,
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
                color: Colors.black, fontSize: size.aspectRatio * 12)),
        SizedBox(
          height: size.height * 0.02,
        ),
        SizedBox(
            width: size.width * 0.8,
            child: TextField(
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
                counterText: 'Ingrese los datos separadas por comas',
                counterStyle: TextStyle(fontSize: size.aspectRatio * 8),
              ),
            )),
      ],
    );
  }

  Widget _rowCheckBoxes(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Checkbox(
                value: isDiscretCheck,
                onChanged: (value) {
                  setState(() {
                    isDiscretCheck = !isDiscretCheck;
                    isContinuesCheck = !isContinuesCheck;
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
          width: size.width * 0.05,
        ),
        Row(
          children: [
            Checkbox(
                value: isContinuesCheck,
                onChanged: (value) {
                  setState(() {
                    isDiscretCheck = !isDiscretCheck;
                    isContinuesCheck = !isContinuesCheck;
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
    );
  }

  Widget _button(Size size) {
    return ElevatedButton(
        onPressed: () {
          controller.dataString = data;
          controller.isDiscrete = isDiscretCheck;
          try {
            controller.makeData();
            Navigator.pushNamed(context, '/result');
          } catch (e) {
            setState(() {
              errorMessage =
                  'Datos erroneos o mal ingresados. Recuerde que deben ingresarse al menos 3 datos no repetidos y separados por comas';
            });
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
        ));
  }
}
