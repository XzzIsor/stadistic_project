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
  static List<double> _cValues = [];
  static double _m = 0;
  static double _aritmeticMean = 0;
  static double _median = 0;
  static double _trend = 0;
  static double _variance = 0;
  static double _standardDeviation = 0;
  static double _coefficientOfVariation = 0;
  static List<double> _ogiveData = [];
  static List<double> _frecuencyData = [];
  static List<double> _intervals = [];
  static List<double> _differentCValues = [];
  String _dataString = '';
  String cValuesString = '';

  set isDiscrete(bool value) {
    _isDiscrete = value;
  }

  set dataString(String value) {
    _dataString = value;
  }

  set data(List<double> value) {
    _data = value;
  }

  List<Data> get dataList => _dataList;
  List<double> get ogiveData => _ogiveData;
  List<double> get frecuencyData => _frecuencyData;
  List<double> get data => _data;

  double get aritmeticMean => _aritmeticMean;
  double get median => _median;
  double get trend => _trend;
  double get variance => _variance;
  double get standardDeviation => _standardDeviation;
  double get coefficientOfVariation => _coefficientOfVariation;
  double get cValue => _cValue;
  double get m => _m;
  bool get isDiscrete => _isDiscrete;

  void makeData() {
    _data.clear();
    _dataList.clear();
    final aux = _dataString.split(',');
    _data = aux.map((e) => double.parse(e)).toList();
    _lenghtN = _data.length;

    if (!_isDiscrete) {
      _getRange();
      _getCValue();
      _organizeContinuosData();
    } else {
      _getCValues();
      _organizeDiscreteData();
    }
    _getCentralTendency();
    _getDispersion();
    _getGraphicsData();
  }

  void makeDataForDifferentCValues() {
    _dataList.clear();
    _makeDifferentCValue();
    _organizeDifferentCData();
    _getTrendForDifferentC();
    _getGraphicsData();
  }

  void _makeDifferentCValue() {
    _differentCValues.clear();
    List<String> list = cValuesString.split(',');
    list.forEach((element) {
      _differentCValues.add(double.parse(element));
    });
  }

  void _organizeDifferentCData() {
    double superiorLimit = _min + _differentCValues[0];
    double inferiorLimit = _min;
    double counter = 0;

    for (int y = 0; y < _m; y++) {
      for (int i = 0; i < _data.length; i++) {
        if (_data[i] >= inferiorLimit && _data[i] < superiorLimit) {
          counter++;
        }
      }
      Data data = Data(li1: 0, li: 0, ni: 0, fi: 0, Ni: 0, Fi: 0, xi: 0, ci: 0);
      if (y == 0) {
        data = Data(
          li1: inferiorLimit,
          li: superiorLimit,
          ni: counter,
          fi: counter / _lenghtN,
          xi: (inferiorLimit + superiorLimit) / 2,
          Ni: counter,
          Fi: counter / _lenghtN,
          ci: _differentCValues[y],
        );
      } else {
        data = Data(
          li1: inferiorLimit,
          li: superiorLimit,
          ni: counter,
          fi: counter / _lenghtN,
          xi: (inferiorLimit + superiorLimit) / 2,
          Ni: counter + _dataList[y - 1].Ni!,
          Fi: (counter / _lenghtN) + _dataList[y - 1].Fi!,
          ci: _differentCValues[y],
        );
      }
      counter = 0;
      _dataList.add(data);

      if (y != _m - 1) {
        inferiorLimit = superiorLimit;
        superiorLimit = superiorLimit + _differentCValues[y + 1];
      }
    }
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

  void _getCValues() {
    _intervals = _data.map((e) => e).toSet().toList();
    _intervals.sort();
    for (int i = 0; i < _intervals.length - 1; i++) {
      _cValues.add(_intervals[i + 1] - _intervals[i]);
    }
  }

  void _organizeContinuosData() {
    double superiorLimit = _min + _cValue;
    double inferiorLimit = _min;
    double counter = 0;

    for (int y = 0; y < _m; y++) {
      for (int i = 0; i < _data.length; i++) {
        if (_data[i] >= inferiorLimit && _data[i] < superiorLimit) {
          counter++;
        }
      }
      Data data = Data(li1: 0, li: 0, ni: 0, fi: 0, Ni: 0, Fi: 0, xi: 0, ci: 0);
      if (y == 0) {
        data = Data(
          li1: inferiorLimit,
          li: superiorLimit,
          ni: counter,
          fi: counter / _lenghtN,
          xi: (inferiorLimit + superiorLimit) / 2,
          Ni: counter,
          Fi: counter / _lenghtN,
          ci: _cValue,
        );
      } else {
        data = Data(
          li1: inferiorLimit,
          li: superiorLimit,
          ni: counter,
          fi: counter / _lenghtN,
          xi: (inferiorLimit + superiorLimit) / 2,
          Ni: counter + _dataList[y - 1].Ni!,
          Fi: (counter / _lenghtN) + _dataList[y - 1].Fi!,
          ci: _cValue,
        );
      }
      counter = 0;
      _dataList.add(data);

      inferiorLimit = superiorLimit;
      superiorLimit = superiorLimit + _cValue;
    }
  }

  void _organizeDiscreteData() {
    double counter = 0;

    for (int i = 0; i < _intervals.length; i++) {
      for (int j = 0; j < _data.length; j++) {
        if (_data[j] == _intervals[i]) {
          counter++;
        }
      }

      Data data = Data(li1: 0, li: 0, ni: 0, fi: 0, Ni: 0, Fi: 0, xi: 0, ci: 0);
      if (i == 0) {
        data = Data(
            li: _intervals[i],
            xi: _intervals[i],
            ni: counter,
            fi: counter / _lenghtN,
            Ni: counter,
            Fi: counter / _lenghtN,
            ci: 0);
      } else {
        data = Data(
            li: _intervals[i],
            xi: _intervals[i],
            ni: counter,
            fi: counter / _lenghtN,
            Ni: counter + _dataList[i - 1].Ni!,
            Fi: (counter / _lenghtN) + _dataList[i - 1].Fi!,
            ci: _intervals[i] - _intervals[i - 1]);
      }

      counter = 0;
      _dataList.add(data);
    }
  }

  void _getAritmeticMean() {
    _aritmeticMean =
        _data.reduce((value, element) => value + element) / _lenghtN;
  }

  void _getMedian() {
    if (_dataList.length.isEven) {
      int index1 = ((_dataList.length / 2) - 2).round();
      int index2 = ((_dataList.length / 2) - 1).round();
      _median = (_dataList[index1].xi! + _dataList[index2].xi!) / 2;
    } else {
      _median = _dataList[(_dataList.length / 2 - 1).round()].xi!;
    }
  }

  void _getTrend() {
    int mainIndex = 0;
    for (int i = 1; i < _dataList.length; i++) {
      if (_dataList[mainIndex].ni < _dataList[i].ni) {
        mainIndex = i;
      }
    }
    if (_isDiscrete) {
      double num1 = (_dataList[mainIndex].fi / _cValues[mainIndex]);
      double num2 = mainIndex != 0
          ? (_dataList[mainIndex - 1].fi / _cValues[mainIndex - 1])
          : 0;
      double num3 = mainIndex != _intervals.length - 1
          ? (_dataList[mainIndex + 1].fi / _cValues[mainIndex + 1])
          : 0;
      double num4 = _dataList[mainIndex].li!;
      _trend =
          (((num1 - num2) / 2 * (num1 - num2 - num3)) * _cValues[mainIndex]) +
              num4;
    } else {
      double num1 = (_dataList[mainIndex].fi / _cValue);
      double num2 =
          mainIndex != 0 ? (_dataList[mainIndex - 1].fi / _cValue) : 0;
      double num3 =
          mainIndex != _m - 1 ? (_dataList[mainIndex + 1].fi / _cValue) : 0;
      double num4 = _dataList[mainIndex].li1!;
      _trend = (((num1 - num2) / 2 * (num1 - num2 - num3)) * _cValue) + num4;
    }
  }

  void _getTrendForDifferentC() {
    int mainIndex = 0;
    for (int i = 1; i < _dataList.length; i++) {
      if (_dataList[mainIndex].ni < _dataList[i].ni) {
        mainIndex = i;
      }
    }

    double num1 = (_dataList[mainIndex].fi / _differentCValues[mainIndex]);
    double num2 = mainIndex != 0
        ? (_dataList[mainIndex - 1].fi / _differentCValues[mainIndex])
        : 0;
    double num3 = mainIndex != _m - 1
        ? (_dataList[mainIndex + 1].fi / _differentCValues[mainIndex])
        : 0;
    double num4 = _dataList[mainIndex].li1!;
    _trend = (((num1 - num2) / 2 * (num1 - num2 - num3)) *
            _differentCValues[mainIndex]) +
        num4;
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
    double valueMin = _aritmeticMean - (k * _standardDeviation);
    double valueMax = _aritmeticMean + (k * _standardDeviation);
    int indexMin = -1;
    int indexMax = -1;

    for (int i = 0; i < _dataList.length; i++) {
      if (valueMin >= _dataList[i].li1! && valueMin < _dataList[i].li!) {
        indexMin = i;
      }
    }

    for (int i = 0; i < _dataList.length; i++) {
      if (valueMax >= _dataList[i].li1! && valueMax < _dataList[i].li!) {
        indexMax = i;
      }
    }

    double result = 0;
    double operation1 = 0;
    double operation2 = 0;

    if (cValuesString == '') {
      if (indexMin == 0) {
        operation1 = (_dataList[indexMin].fi / cValue) *
            (valueMin - _dataList[indexMin].li1!);
      } else if (indexMin == -1) {
        operation1 = 0;
      } else {
        operation1 = _dataList[indexMin - 1].Fi! +
            ((_dataList[indexMin].fi / cValue) *
                (valueMin - _dataList[indexMin - 1].li1!));
      }

      if (indexMax == -1) {
        operation2 = 1;
      } else {
        operation2 = _dataList[indexMax - 1].Fi! +
            ((_dataList[indexMax].fi / cValue) *
                (valueMax - _dataList[indexMax].li1!));
      }
    } else {
      if (indexMin == 0) {
        operation1 = (_dataList[indexMin].fi / _differentCValues[0]) *
            (valueMin - _dataList[indexMin].li1!);
      } else if (indexMin == -1) {
        operation1 = 0;
      } else {
        operation1 = _dataList[indexMin - 1].Fi! +
            ((_dataList[indexMin].fi / _differentCValues[indexMin]) *
                (valueMin - _dataList[indexMin - 1].li1!));
      }

      if (indexMax == -1) {
        operation2 = 1;
      } else {
        operation2 = _dataList[indexMax - 1].Fi! +
            ((_dataList[indexMax].fi / _differentCValues[indexMax]) *
                (valueMax - _dataList[indexMax].li1!));
      }
    }

    result = operation2 - operation1;

    return result;
  }

  void _getGraphicsData() {
    _ogiveData.clear();
    _frecuencyData.clear();
    for (var element in _dataList) {
      _ogiveData.add(element.Fi! * 100);
    }

    if (cValuesString == '') {
      for (var element in dataList) {
        _frecuencyData.add(element.fi * 100);
      }
    } else {
      for (int i = 0; i < dataList.length; i++) {
        _frecuencyData.add((dataList[i].fi / _differentCValues[i]) * 100);
      }
    }
  }
}
