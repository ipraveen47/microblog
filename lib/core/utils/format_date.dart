import 'package:intl/intl.dart';

String formatDateByMMMYYYY(DateTime dateTime) {
  return DateFormat("d MMM, YYYY").format(dateTime);
}
