import 'dart:developer';

class Utils {
  static String capitalizeWord(String word) {
    if (word.isEmpty) return word;

    if (word.length == 1) return word[0].toUpperCase();

    return word[0].toUpperCase() + word.substring(1);
  }

  static int minutesByHoursAndTime({int? hours, int? minutes}) {
    return (hours ?? 0) * 60 + (minutes ?? 0);
  }

  static String hoursAndMinutesByMinutes(int totalMinutes) {
    log("TSK hoursAndMinutesByMinutes - $totalMinutes");
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');

    return '${formattedHours}h ${formattedMinutes}m';
  }
}
