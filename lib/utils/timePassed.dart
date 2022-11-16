String timePassed(DateTime time) {
  DateTime now = DateTime.now();
  Duration diff = now.difference(time);
  String msg = '';
  var passed = diff.inMinutes;
  if (passed < 1) {
    msg = 'Just';
  } else if (passed < 60) {
    msg = '$passed minutes ago';
  } else {
    passed = diff.inHours;
    if (passed < 24) {
      msg = '$passed hour ago';
    } else {
      passed = diff.inDays;
      if (passed < 40) {
        msg = '$passed day ago';
      }
    }
  }

  return msg;
}
