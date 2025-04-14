import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  final format = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$ ',
    decimalDigits: 2,
  );  
  return format.format(amount);
}

double formatAmount(int amount) {
  // Convert amount to double and format it
  double formattedAmount = amount / 100;
  return double.parse(formattedAmount.toStringAsFixed(2));
}

String formatDateTime(DateTime dateTime, {String pattern = 'y MMMM d h:mma', String? locale}) {
  return DateFormat(pattern, locale).format(dateTime);
}
