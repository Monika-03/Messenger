import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  //keys
  static String userLoggedinkey="LOGGEDINKEY";
  static String usernamekey = "NAMEKEY";
  static String useremailkey = "EMAILKEY";



  // SAVING DATA
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedinkey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(usernamekey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(useremailkey, userEmail);
  }

  //getting data from sf
  static Future<bool?> getUserLoggedInStatus ()async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedinkey);
  }
  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(useremailkey);
  }

  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(usernamekey);
  }
}