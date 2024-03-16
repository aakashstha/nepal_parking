String convert12To24(String time) {
  String convertedTime = '';
  String hours = time.split(':')[0];
  String minutes = time.split(':')[1].substring(0, 2);
  String period = time.split(' ')[1];

  if (period == 'AM') {
    convertedTime = '${hours == '12' ? '00' : hours}:$minutes';
  } else {
    convertedTime =
        '${hours == '12' ? '12' : (int.parse(hours) + 12).toString()}:$minutes';
  }

  return convertedTime;
}
