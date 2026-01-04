import 'package:intl/intl.dart';

class Formatters {
  // Date formatters
  static final DateFormat dateFormatter = DateFormat('MMM dd, yyyy');
  static final DateFormat dateTimeFormatter = DateFormat('MMM dd, yyyy - HH:mm');
  static final DateFormat timeFormatter = DateFormat('HH:mm');
  
  // Number formatters
  static final NumberFormat currencyFormatter = NumberFormat.currency(
    symbol: 'EGP ',
    decimalDigits: 2,
  );
  
  static final NumberFormat numberFormatter = NumberFormat('#,##0');
  
  // Format currency
  static String formatCurrency(double amount) {
    return currencyFormatter.format(amount);
  }
  
  // Format date
  static String formatDate(DateTime date) {
    return dateFormatter.format(date);
  }
  
  // Format date time
  static String formatDateTime(DateTime date) {
    return dateTimeFormatter.format(date);
  }
  
  // Format number
  static String formatNumber(int number) {
    return numberFormatter.format(number);
  }
}

