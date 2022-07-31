class DataController {
  static List<double> _data = [];
  static bool _isDiscrete = false;
  String _dataString = '';

  set isDiscrete(bool value) {
    _isDiscrete = value;
  }

  set dataString(String value) {
    _dataString = value;
  }

  void makeData() {
    final aux = _dataString.split(',');
    _data = aux.map((e) => double.parse(e)).toList();
    print(_data);
  }
}
