import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Format {
  static String rupiahConvert(double value) {
    String lastValue = '';
    //rounding condition
    // Get.log('value : $value');
    if (value.toString().contains('.') &&
        value.toString().split('.').last != '0') {
      var split = value.toString().split('.');
      lastValue = split.last;
      value = double.tryParse(split.first) ?? 0;
    }
    // final currencyFormatter = NumberFormat.currency(locale: 'ID');
    final currencyFormatter = NumberFormat('#,##0', 'ID');
    return 'Rp. ${currencyFormatter.format(value)}${lastValue.isNotEmpty ? ',$lastValue' : ''}';
  }
}
