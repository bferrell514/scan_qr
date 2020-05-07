import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scanqr/Constant/Constant.dart';

class StartScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Widget Logo(){
      return Container(
        height: 250,
        width: 250,

        child: ClipRRect(
          borderRadius:
          const BorderRadius.all(Radius.circular(60.0)),
          child: Image.asset('assets/images/Logo.png'),
        ),
      );
    }

    Widget LoginButton(){
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Center(
          child: Container(
            width: 200,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius:
                const BorderRadius.all(Radius.circular(4.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  offset: const Offset(4, 4),
                  blurRadius: 8.0
                )
              ]
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (){
                  FocusScope.of(context).requestFocus(FocusNode());
                  Navigator.of(context).pushNamed(LOGIN_SCREEN);
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget RegisterButton(){
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Center(
          child: Container(
            width: 200,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius:
                const BorderRadius.all(Radius.circular(4.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      offset: const Offset(4, 4),
                      blurRadius: 8.0
                  )
                ]
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (){
                  FocusScope.of(context).requestFocus(FocusNode());
                  Navigator.of(context).pushNamed(REGISTER_SCREEN);
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'REGISTER',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        
          child: Column(
           children: <Widget>[
             Expanded(
               child: Container(),
               flex: 1,
             ),
             Expanded(
               child: Logo(),
               flex: 4,
             ),
             Expanded(
               child: Container(),
               flex: 1,
             ),
             Expanded(
               child: LoginButton(),
               flex: 1,
             ),
             Expanded(
               child: RegisterButton(),
               flex: 1,
             ),
             Expanded(
               child: Container(),
               flex: 2,
             )
           ],
          ),
      ),
    );
  }
}

