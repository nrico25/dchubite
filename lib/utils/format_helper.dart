import 'package:intl/intl.dart';

String formatRupiah(num number) {
  final formatter = NumberFormat("#,##0", "en_US");
  return formatter.format(number);
}
