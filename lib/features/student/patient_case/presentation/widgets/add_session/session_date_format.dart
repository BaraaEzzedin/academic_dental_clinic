// Lightweight date formatting helpers for the "Add New Session" sheet.
// Kept local (no intl dependency) to match the app's current setup.

const List<String> _monthsShort = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

const List<String> _monthsLong = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

// DateTime.weekday: Mon = 1 ... Sun = 7.
const List<String> _weekdaysShort = [
  'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
];

// e.g. "July 2026"
String formatMonthYear(DateTime date) =>
    '${_monthsLong[date.month - 1]} ${date.year}';

// e.g. "Tue, Jul 28"
String formatDayLabel(DateTime date) {
  final weekday = _weekdaysShort[date.weekday - 1];
  return '$weekday, ${_monthsShort[date.month - 1]} ${date.day}';
}

// e.g. "Aug 12, 2026" — matches the Session.date string format.
String formatSessionDate(DateTime date) =>
    '${_monthsShort[date.month - 1]} ${date.day}, ${date.year}';

bool isSameDay(DateTime? a, DateTime? b) =>
    a != null &&
    b != null &&
    a.year == b.year &&
    a.month == b.month &&
    a.day == b.day;