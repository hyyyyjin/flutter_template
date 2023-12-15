import 'package:untitled2/common/const/data.dart';

class DataUtils {
  static String pathToUrl(String value) {
    return 'http://$ip$value';
  }

  static List<String> listPathToUrls(List paths) {
    print ('listPathToUrls $paths');
    return paths.map((e) => pathToUrl(e)).toList();
  }
}
