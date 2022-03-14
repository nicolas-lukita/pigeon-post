import 'package:pigeon_post/helper/current_user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";
  static String sharedPreferenceUserImageUrlKey = "USERIMAGEURLKEY";

  // save login status, email, username in shared preference
  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserEmailSharedPreference(String userEmail) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  static Future<bool> saveUserNameSharedPreference(String userName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserImageUrlSharedPreference(String imageUrl) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString(sharedPreferenceUserImageUrlKey, imageUrl);
  }

  // get login status, email, username from shared preference
  static Future<bool?> getUserLoggedInSharedPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String?> getUserEmailSharedPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return  pref.getString(sharedPreferenceUserEmailKey);
  }

  static Future<String?> getUserNameSharedPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(sharedPreferenceUserNameKey);
  }

  static Future<String?> getUserImageUrlSharedPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(sharedPreferenceUserImageUrlKey);
  }

  static getCurrentUserData() async {
    CurrentUserData.username =
        (await HelperFunctions.getUserNameSharedPreference())!;
    CurrentUserData.userEmail =
        (await HelperFunctions.getUserEmailSharedPreference())!;
  }

  // chatroom related functions
  static String chatRoomIdGenerator(String uid1, String uid2) {
    int uid1_sum = 0;
    int uid2_sum = 0;

    //calculate the whole string numerical value
    for (int i = 0; i < uid1.length; i++) {
      uid1_sum += uid1.substring(0).codeUnitAt(i);
    }

    for (int i = 0; i < uid2.length; i++) {
      uid2_sum += uid2.substring(0).codeUnitAt(i);
    }

    // always return id of "smallerUID_largerUID"
    if (uid1_sum < uid2_sum) {
      return "$uid1\_$uid2";
    } else {
      return "$uid2\_$uid1";
    }
  }
}
