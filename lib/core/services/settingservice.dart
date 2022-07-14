import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingServices extends GetxService {
  late SharedPreferences sharedPrefs;

  Future<SettingServices> init() async {
    sharedPrefs = await SharedPreferences.getInstance();
    return this;
  }
}
