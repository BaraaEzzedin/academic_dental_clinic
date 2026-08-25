class DateFormatter {
  DateFormatter._();

  static const List<String> monthsShort = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static const List<String> monthsLong = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  // DateTime.weekday: Mon = 1 ... Sun = 7.
  static const List<String> weekdaysShort = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  /// e.g. "Aug 12, 2003".
  static String toMediumDate(DateTime date) =>
      '${monthsShort[date.month - 1]} ${date.day}, ${date.year}';

  /// e.g. "Wed, Aug 5".
  static String toDayLabel(DateTime date) =>
      '${weekdaysShort[date.weekday - 1]}, '
      '${monthsShort[date.month - 1]} ${date.day}';

  /// e.g. "July 2026".
  static String toMonthYear(DateTime date) =>
      '${monthsLong[date.month - 1]} ${date.year}';

  /// Parses an ISO 8601 string and formats it as a medium date
  /// (e.g. "Aug 12, 2003"). Returns the raw value if it can't be parsed and
  /// an empty string when [raw] is null or empty.
  static String mediumDateFromIso(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    final date = DateTime.tryParse(raw);
    if (date == null) return raw;
    return toMediumDate(date);
  }

  /// Formats a `HH:mm[:ss]` time string as a 12-hour label, e.g.
  /// "09:00:00" -> "9:00 AM". Returns the raw value if it can't be parsed and
  /// an empty string when [raw] is null or empty.
  static String toTimeOfDay(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    final parts = raw.split(':');
    if (parts.length < 2) return raw;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return raw;
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return '$hour12:${minute.toString().padLeft(2, '0')} $period';
  }

  /// Formats a date as an ISO calendar date (`yyyy-MM-dd`), e.g. "2026-08-09".
  /// Suitable for query parameters.
  static String toIsoDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  /// True when [a] and [b] fall on the same calendar day.
  static bool isSameDay(DateTime? a, DateTime? b) =>
      a != null &&
      b != null &&
      a.year == b.year &&
      a.month == b.month &&
      a.day == b.day;
}