import 'dart:math';

import 'package:stadistic/src/data.dart';

class DataController {
  static List<double> _data = [];
  static int _lenghtN = 0;
  static List<Data> _dataList = [];
  static bool _isDiscrete = false;
  static double _min = 0.0;
  static double _max = 0.0;
  static double _range = 0;
  static double _cValue = 0;
  static double _m = 0;
  static double _aritmeticMean = 0;
  static double _median = 0;
  static double _trend = 0;
  static double _variance = 0;
  static double _standardDeviation = 0;
  static double _coefficientOfVariation = 0;
  static List<double> _ogiveData = [];
  String _dataString = '';

  set isDiscrete(bool value) {
    _isDiscrete = value;
  }

  set dataString(String value) {
    _dataString = value;
  }

  List<Data> get dataList => _dataList;
  List<double> get ogiveData => _ogiveData;
  List<double> get data => _data;

  double get aritmeticMean => _aritmeticMean;
  double get median => _median;
  double get trend => _trend;
  double get variance => _variance;
  double get standardDeviation => _standardDeviation;
  double get coefficientOfVariation => _coefficientOfVariation;
  double get cValue => _cValue;

  void makeData() {
    final aux = _dataString.split(',');
    _data = aux.map((e) => double.parse(e)).toList();
    _lenghtN = _data.length;
    _getRange();
    _getCValue();
    _isDiscrete ? _organizeDiscretData() : _organizeContinuousData();
    _getCentralTendency();
    _getDispersion();
    _getGraphicsData();
  }

  void _getRange() {
    _min = _data.reduce((value, element) => value < element ? value : element);
    _max = _data.reduce((value, element) => value > element ? value : element);
    final nDecimalMin = _min.toString().split(".");
    final nDecimalMax = _max.toString().split(".");

    if (nDecimalMin.length == 1) {
      _min = _min - 0.5;
    } else if (nDecimalMin.length == 2) {
      _min = _min - 0.05;
    }

    if (nDecimalMax.length == 1) {
      _max = _max + 0.5;
    } else if (nDecimalMax.length == 2) {
      _max = _max + 0.05;
    }

    _range = _max - _min;
  }

  void _getCValue() {
    double numlog = 3.3 * log(_lenghtN) / log(10);
    _m = 1 + numlog;
    _m = _m.roundToDouble();
    _cValue = _range / _m;
  }

  void _organizeDiscretData() {
    double superiorLimit = _min + _cValue;
    double inferiorLimit = _min;
    double counter = 0;

    for (int y = 0; y < _m; y++) {
      for (int i = 0; i < _data.length; i++) {
        if (_data[i] >= inferiorLimit && _data[i] < superiorLimit) {
          counter++;
        }
      }
      Data data = Data(li1: 0, li: 0, ni: 0, fi: 0, Ni: 0, Fi: 0, xi: 0);
      if (y == 0) {
        data = Data(
          li1: inferiorLimit,
          li: superiorLimit,
          ni: counter,
          fi: counter / _lenghtN,
          xi: (inferiorLimit + superiorLimit) / 2,
          Ni: counter,
          Fi: counter / _lenghtN,
        );
      } else {
        data = Data(
            li1: inferiorLimit,
            li: superiorLimit,
            ni: counter,
            fi: counter / _lenghtN,
            xi: (inferiorLimit + superiorLimit) / 2,
            Ni: counter + _dataList[y - 1].Ni!,
            Fi: (counter / _lenghtN) + _dataList[y - 1].Fi!);
      }
      counter = 0;
      _dataList.add(data);

      inferiorLimit = superiorLimit;
      superiorLimit = superiorLimit + _cValue;
    }
  }

  void _organizeContinuousData() {
    //TODO: Hacer esta madre
  }

  void _getAritmeticMean() {
    _aritmeticMean =
        _data.reduce((value, element) => value + element) / _lenghtN;
  }

  void _getMedian() {
    if (_data.length.isEven) {
      int index1 = ((_data.length / 2) - 1).round();
      int index2 = (_data.length / 2).round();
      _median = (_data[index1] + _data[index2]) / 2;
    } else {
      _median = _data[(_data.length / 2).round()];
    }
  }

  void _getTrend() {
    int mainIndex = 0;
    for (int i = 1; i < _dataList.length; i++) {
      if (_dataList[mainIndex].ni < _dataList[i].ni) {
        mainIndex = i;
      }
    }

    double num1 = (_dataList[mainIndex].fi / _cValue);
    double num2 = mainIndex != 0 ? (_dataList[mainIndex - 1].fi / _cValue) : 0;
    double num3 =
        mainIndex != _m - 1 ? (_dataList[mainIndex + 1].fi / _cValue) : 0;
    double num4 = _dataList[mainIndex].li1;
    _trend = (((num1 - num2) / 2 * (num1 - num2 - num3)) * _cValue) + num4;
  }

  void _getCentralTendency() {
    _getAritmeticMean();
    _getMedian();
    _getTrend();
  }

  void _getVariance() {
    double sum = 0;
    for (int i = 0; i < _data.length; i++) {
      sum += pow((_data[i] - _aritmeticMean), 2);
    }
    _variance = sum / _lenghtN;
  }

  void _getStandardDeviation() {
    _standardDeviation = sqrt(_variance);
  }

  void _getCoefficientOfVariation() {
    _coefficientOfVariation = _standardDeviation / _aritmeticMean;
  }

  void _getDispersion() {
    _getVariance();
    _getStandardDeviation();
    _getCoefficientOfVariation();
  }

  double getTchebycheff(int k) {
    double valueMin = _aritmeticMean - (2 * _standardDeviation);
    double valueMax = _aritmeticMean + (2 * _standardDeviation);
    int indexMin = 0;
    int indexMax = 1;

    for (int i = 0; i < _dataList.length; i++) {
      if (valueMin >= _dataList[i].li1 && valueMin < _dataList[i].li) {
        indexMin = i;
      }
    }

    for (int i = 0; i < _dataList.length; i++) {
      if (valueMax >= _dataList[i].li1 && valueMax < _dataList[i].li) {
        indexMax = i;
      }
    }

    double operation1 = (_dataList[indexMin].fi / _cValue) +
        ((_dataList[indexMin].Ni! / _cValue) *
            (valueMin - _dataList[indexMin].li1));
    double operation2 = (_dataList[indexMax].fi / _cValue) +
        ((_dataList[indexMax].Ni! / _cValue) *
            (valueMax - _dataList[indexMax].li1));
    double result = operation2 - operation1;

    return result;
  }

  void _getGraphicsData() {
    for (var element in _dataList) {
      _ogiveData.add(element.Fi! * 100);
    }
  }
}
