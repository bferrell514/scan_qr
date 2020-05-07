import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scanqr/Constant/Constant.dart';

class ScanScreen extends StatefulWidget{

  final String item_url;
  final String item_name;
  final int item_quantity;
  final String barcode;

  const ScanScreen({Key key, this.item_url, this.item_name, this.item_quantity, this.barcode}) : super(key: key);

  @override
  _MyScanScreen createState() => _MyScanScreen(item_url, item_name, item_quantity, barcode);

}

class _MyScanScreen extends State<ScanScreen>{

  final FirebaseAuth auth = FirebaseAuth.instance;

  String item_url = "";
  String item_name = "";
  int item_quantity = 0;
  String barcode = "";

  int change_quantity = 0;

  bool isSwitched = false;
  bool isIncrease = false;


  _MyScanScreen(String item_url, String item_name, int item_quantity, String barcode){
    this.item_url = item_url;
    this.item_name = item_name;
    this.item_quantity = item_quantity;
    this.barcode = barcode;
  }

  @override
  void initState() {

    super.initState();
    if(item_url == null){
      scan();
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget SignOut(){
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Container(),
              flex: 3,
            ),
            Flexible(
              child: Center(
                child: FlatButton(
                  onPressed: () => {
                    auth.signOut(),
                    Navigator.of(context).pushReplacementNamed(START_SCREEN)
                  },
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Text('SIGN OUT',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        flex: 8,
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(Icons.exit_to_app),
                        ),
                        flex: 1,
                      )
                    ],
                  ),
                ),
              ),
              flex: 2,
            )
          ],
        ) ,
      );
    }

    Widget Image_Url(){
      return Center(
        child: item_url != null
            ? CachedNetworkImage(
                height: 240,
                width: 240,
                imageUrl: item_url,
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              )
            : Container()
      );
    }

    Widget Title_Quantity(){
      return Center(
        child:Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child:  Column(
            children: <Widget>[
              Flexible(
                child: Text(
                  '$item_name',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
                  ),
                ),
                flex: 2,
              ),
              SizedBox(height: 20,),
              Flexible(
                child: Text(
                  'Quantity  $item_quantity',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17.0
                  ),
                ),
                flex: 1,
              )
            ],
          ),
        )
      );
    }

    Widget Control_Quantity(){
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Ink(
                height: 40,
                width: 40,
                decoration: const ShapeDecoration(
                    shape: CircleBorder(),
                    color: Colors.black
                ),
                child: IconButton(
                  icon: Icon(Icons.remove),
                  color: Colors.white,
                  onPressed: (){

                    setState(() {

                      isIncrease = false;
                      if(change_quantity == 0){
                        return;
                      }

                      Data_change_quantity();
                    });
                  },
                ),
              ),
            ),
            SizedBox(width: 20,),
            Container(
              height: 60,
              width: 140,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                border: new Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              child: Center(
                child: Text(
                  '$change_quantity',
                  style: TextStyle(
                    fontSize: 20
                  ),
                ),
              )
            ),
            SizedBox(width: 20,),
            Center(
                child: Ink(
                  height: 40,
                  width: 40,
                  decoration: const ShapeDecoration(
                      shape: CircleBorder(),
                      color: Colors.black
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add),
                    color: Colors.white,
                    onPressed: (){

                      setState(() {

                        isIncrease = true;

                        Data_change_quantity();
                      });
                    },
                  ),
                ),
            )
          ],
        ),
      );
    }

    Widget Toggle(){
      return Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: Row(
          children: <Widget>[
            Text(
              'Remove',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18
              ),
            ),
            Switch(
              value: isSwitched,
              onChanged: (value){
                setState(() {
                  isSwitched = value;
                  change_quantity = 0;
                  print(isSwitched);
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
            Text(
              'Return',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18
              ),
            )
          ],
        ),
      );
    }

    return WillPopScope(
      child: Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              Expanded(
                child: SignOut(),
                flex: 1,
              ),
              Expanded(
                child: Image_Url(),
                flex: 3,
              ),
              Expanded(
                child: Title_Quantity(),
                flex: 2,
              ),
              Expanded(
                child: Control_Quantity(),
                flex: 1,
              ),
              Expanded(
                child: Container(),
                flex: 1,
              ),
              Expanded(
                child: Toggle(),
                flex: 1,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          //onPressed: () => _scan(),
          onPressed: (){
            scan();
          },
          tooltip: 'Take a Photo',
          child: const Icon(Icons.camera_alt),
        ),
      ),
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Warning'),
          content: Text('Do you really want to exit?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                SystemNavigator.pop();
              }
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(c, false),
            )
          ],
        )
      ),
    );
  }

  //------- scan QR code and read data from firestore ---------------

  Future scan() async{
    String barcode = await scanner.scan();
    ReadFirestore(barcode);
  }

  ReadFirestore(String barcode) {

    String item_url, item_name;
    int item_quantity;
    String Barcode;

    Barcode = barcode;

    Firestore.instance
        .collection("inventory_items")
        .where("docId", isEqualTo: barcode)
        .getDocuments()
        .then((QuerySnapshot docs){

      if(docs.documents.isNotEmpty){

        var data = docs.documents[0].data;

        String itemurl = 'item_image_url';
        String itemname = 'item_name';
        String itemquantity = 'item_quantity';

        if(data.containsKey(itemurl)){
          var score = data[itemurl];
          item_url = score;
        }

        if(data.containsKey(itemname)){
          var score = data[itemname];
          item_name = score;
        }

        if(data.containsKey(itemquantity)){
          var score = data[itemquantity];
          item_quantity = score;
        }

        send_data(item_url, item_name, item_quantity, Barcode );

      }else{
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ScanScreen(item_url: "", item_name: "", item_quantity: 0,)
            )
        );
      }
    });
  }

  send_data(String url, String name, int quantity, String barcode){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ScanScreen(item_url: url, item_name: name, item_quantity: quantity, barcode: barcode, )
        )
    );
  }

  //-------- change Firestore item quantity value --------------

  Data_change_quantity(){

    Firestore.instance
        .collection("inventory_items")
        .where("docId", isEqualTo: barcode)
        .getDocuments()
        .then((QuerySnapshot docs){
          if(docs.documents.isNotEmpty) {
            var data = docs.documents[0].data;
            String fieldName = 'item_quantity';

            if (data.containsKey(fieldName)) {
              var score = data[fieldName];

              if (isSwitched) {

                if(isIncrease){

                  change_quantity++;
                  docs.documents[0]
                      .reference.updateData({
                    fieldName: score + 1,

                  });

                  change_screen_quantity_value();

                }else{

                  change_quantity--;
                  docs.documents[0]
                      .reference.updateData({
                    fieldName: score - 1,
                  });

                  change_screen_quantity_value();
                }

              } else {

                if(isIncrease){

                  if(item_quantity == 0){
                    return;
                  }

                  change_quantity++;
                  docs.documents[0]
                      .reference.updateData({
                    fieldName: score - 1,

                  });

                  change_screen_quantity_value();

                }else{

                  change_quantity--;
                  docs.documents[0]
                      .reference.updateData({
                    fieldName: score + 1,
                  });

                  change_screen_quantity_value();
                }
              };
            }
          }
        }
    );
  }


  change_screen_quantity_value(){
    Firestore.instance
        .collection("inventory_items")
        .where("docId", isEqualTo: barcode)
        .getDocuments()
        .then((QuerySnapshot docs){
          if(docs.documents.isNotEmpty){
            var data = docs.documents[0].data;
            String fieldName = 'item_quantity';

            if(data.containsKey(fieldName)){
              int score = data[fieldName];
              setState(() {
                item_quantity = score;
              });

            }
          }
    });
  }

}