import 'package:intl/intl.dart';

class TextFormat {
  static String currency(num number) {
    return NumberFormat.simpleCurrency().format(number);
  }

  static String formatNum(num number) {
    return NumberFormat().format(number);
  }
}
