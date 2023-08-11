import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';


class CoudMessagingService {

  // method to get the token
  Future<String?> getToken() async {
    // get instance of FirebaseMessaging
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    // get token
    String? token = null;
    if(kIsWeb){
      // for web
      token = await messaging.getToken(vapidKey: 'BDdcza94kgaq56SwgWfORo1exq-Qkvj2zKtpfMI5uh0Htw1qXlDaoc5qRpSkqRvob2He3v_dJiYAah-vE-u4ed4');
    }else{
      // for mobile
      token = await messaging.getToken();
    }
    // return token
    return token;
  }


}