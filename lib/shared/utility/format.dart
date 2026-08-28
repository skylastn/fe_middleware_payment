import 'package:intl/intl.dart';

class Format {
  static String rupiahConvert(double value) {
    String lastValue = '';
    if (value.toString().contains('.') &&
        value.toString().split('.').last != '0') {
      var split = value.toString().split('.');
      lastValue = split.last;
      value = double.tryParse(split.first) ?? 0;
    }
    final currencyFormatter = NumberFormat('#,##0', 'ID');
    return 'Rp. ${currencyFormatter.format(value)}${lastValue.isNotEmpty ? ',$lastValue' : ''}';
  }
}
