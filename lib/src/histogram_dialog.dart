import 'package:flutter/material.dart';

class HistogramDialog {
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
        color: const Color.fromARGB(255, 38, 159, 175),
      ),
    );
  }
}
