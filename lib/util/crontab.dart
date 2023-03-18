class CrontabParser {
  int? _minute;
  int? _hour;
  int? _dayOfMonth;
  int? _month;
  int? _dayOfWeek;

  CrontabParser(String expression) {
    List<String> fields = expression.split(' ');
    _minute = _parseField(fields[0], 0, 59);
    _hour = _parseField(fields[1], 0, 23);
    _dayOfMonth = _parseField(fields[2], 1, 31);
    _month = _parseField(fields[3], 1, 12);
    _dayOfWeek = _parseField(fields[4], 1, 7);
  }

  int? _parseField(String field, int min, int max) {
    if (field == '*') {
      return null;
    }
    int value = int.parse(field);
    if (value < min || value > max) {
      throw ArgumentError('Field value out of range: $field');
    }
    return value;
  }

  bool isScheduledTime(DateTime time) {
    if (_dayOfWeek != null && _dayOfWeek != time.weekday) {
      return false;
    }
    if (_month != null && _month != time.month) {
      return false;
    }
    if (_dayOfMonth != null && _dayOfMonth != time.day) {
      return false;
    }
    if (_hour != null && _hour != time.hour) {
      return false;
    }
    if (_minute != null && _minute != time.minute) {
      return false;
    }
    return true;
  }

  List<DateTime> getNextSevenRunTimes() {
    DateTime now = DateTime.now();
    DateTime nextRunTime = DateTime(
        now.year, now.month, now.day, _hour ?? 0, _minute ?? 0, 0, 0, 0);
    if (nextRunTime.isBefore(now)) {
      nextRunTime = nextRunTime.add(const Duration(days: 1));
    }
    List<DateTime> nextSevenRunTimes = [];
    for (int i = 0; i < 7; i++) {
      while (!isScheduledTime(nextRunTime)) {
        nextRunTime = nextRunTime.add(const Duration(minutes: 1));
        if (nextRunTime.hour == 0 && nextRunTime.minute == 0) {
          nextRunTime =
              DateTime(nextRunTime.year, nextRunTime.month, nextRunTime.day + 1, 0, 0, 0, 0, 0);
        }
      }
      nextSevenRunTimes.add(nextRunTime);
      nextRunTime = nextRunTime.add(const Duration(minutes: 1));
    }
    return nextSevenRunTimes;
  }
}
