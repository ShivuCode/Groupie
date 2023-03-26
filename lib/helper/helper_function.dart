import 'package:shared_preferences/shared_preferences.dart';
class HelperFunction{
  static String userLoggedKey="LOGGEDINEY";
  static String userNameKey="USERNAMEKEY";
  static String userEmailKey="USEREMAILKEY";

  //saving the data
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn)async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return sf.setBool(userLoggedKey,isUserLoggedIn);
  }
  static Future<bool> saveUserName(String userName)async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return sf.setString(userNameKey,userName);
  }
  static Future<bool> saveUserEmail(String userEmail)async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return sf.setString(userEmailKey,userEmail);
  }


  //getting the data
  static Future<bool?> getUserLoggedStatus()async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return sf.getBool(userLoggedKey);
  }
  static Future<String?> getUserEmailFromSf()async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }
  static Future<String?> getUserNameFromSf()async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }
}