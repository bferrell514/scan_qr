import 'package:flutter/material.dart';
import 'package:scanqr/Constant/Constant.dart';
import 'package:scanqr/Main/Login/LoginScreen.dart';
import 'package:scanqr/Main/Register/RegisterScreen.dart';
import 'package:scanqr/Main/StartScreen.dart';
import 'package:scanqr/Main/Scan/ScanScreen.dart';
import 'package:scanqr/Main/Auth.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  final Auth _auth = Auth();
  final bool isLogged = await _auth.isLogged();
  final MyApp myApp = MyApp(
    initialRoute: isLogged ? SCAN_SCREEN : START_SCREEN,
  );
  runApp(myApp);
}

class MyApp extends StatelessWidget{
  final String initialRoute;

  const MyApp({Key key, this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,

      routes: <String, WidgetBuilder>{
        START_SCREEN:(BuildContext context) => new StartScreen(),
        LOGIN_SCREEN: (BuildContext context) => new LoginScreen(),
        REGISTER_SCREEN: (BuildContext context) => new RegisterScreen(),
        SCAN_SCREEN: (BuildContext context) => new ScanScreen(),
      },

    );
  }

}
