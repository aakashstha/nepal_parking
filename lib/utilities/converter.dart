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

String convert24To12(String time) {
  String convertedTime = '';
  String hours = time.split(':')[0];
  String minutes = time.split(':')[1];

  int hoursInt = int.parse(hours);

  if (hoursInt == 0) {
    convertedTime = '12:$minutes AM';
  } else if (hoursInt < 12) {
    convertedTime = '$hours:$minutes AM';
  } else if (hoursInt == 12) {
    convertedTime = '12:$minutes PM';
  } else {
    convertedTime = '${hoursInt - 12}:$minutes PM';
  }

  print(convertedTime);

  return convertedTime;
}
