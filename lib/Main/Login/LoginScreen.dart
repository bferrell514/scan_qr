import 'package:flutter/material.dart';
import 'package:scanqr/Constant/Constant.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scanqr/Main/Scan/ScanScreen.dart';


class LoginScreen extends StatefulWidget{

 @override
  _MyLoginScreen createState() => _MyLoginScreen();

}

class _MyLoginScreen extends State<LoginScreen>{

  final FirebaseAuth auth = FirebaseAuth.instance;

  String _emailId;
  String _passwordId;

  bool passwordVisible;

  bool emailValid;

  @override
  void initState() {
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {

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

    Widget Email(){
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: new Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                onChanged: (text){
                  _emailId = text;
                  emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailId);
                },
                decoration: new InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your Email",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: new BorderSide(),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
            ],
          ),
        )
      );
    }

    Widget Password(){
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: new TextFormField(
          onChanged: (text){
            _passwordId = text;
          },
          decoration: new InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(10.0),
                borderSide: new BorderSide(),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: (){
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
              )
          ),
          validator: (val){
            if(val.length == 0){
              return "Password cannot be empty";
            }else{
              return null;
            }
          },
          keyboardType: TextInputType.text,
          obscureText: passwordVisible,
          style: new TextStyle(
            fontFamily: "Poppins",
          ),
        ),
      );
    }

    Widget LoginButton(){
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Center(
          child: Container(
            width: 300,
            height: 60,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius:
                const BorderRadius.all(Radius.circular(10.0)),
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
                  checkText();
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


    return Scaffold(
      body: Center(

        child: SingleChildScrollView(

          child: Column(
            children: <Widget>[
              SizedBox(height: 60.0,),
              Logo(),
              SizedBox(height: 60.0,),
              Email(),
              SizedBox(height: 20.0,),
              Password(),
              SizedBox(height: 20.0,),
              LoginButton(),
              SizedBox(height: 20.0,)

            ],
          ),
        ),
      ),
    );
  }


  Future<FirebaseUser> handleSignInEmail(String email, String password) async {

    AuthResult result = await auth.signInWithEmailAndPassword(email: email, password: password);

    final FirebaseUser user = result.user;

    assert(user != null);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await auth.currentUser();
    assert(user.uid == currentUser.uid);

    print('signInEmail successed: $user');
    return user;
  }
  
  checkText(){
    if(emailValid == false){
      showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text("Warning"),
            content: new Text("Please input correct Email!"),
            actions: <Widget>[
              FlatButton(
                child: Text('ok', style: TextStyle(fontSize: 20)),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          )
      );
    }else if(_passwordId.length < 6){
      showDialog(
          context: context,
          child: new AlertDialog(
              title: new Text("Warning"),
              content: new Text("Password can't be lower 6 characters."),
              actions: <Widget>[
                FlatButton(
                  child: Text('ok', style: TextStyle(fontSize: 20)),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                )
              ],
        )
      );
    }else{
      handleSignInEmail(_emailId, _passwordId)
          .then((FirebaseUser user){
        Navigator.of(context).pushReplacementNamed(SCAN_SCREEN);
      }).catchError((e) {
        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Warning"),
              content: new Text('Login is failed!'),
              actions: <Widget>[
                FlatButton(
                  child: Text('ok', style: TextStyle(fontSize: 20),),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                )
              ],
            )
          );
        }
      );
    }
  }

}