import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:navidad_bogota/HomeController.dart';

import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Rutas extends StatelessWidget{

  HomeController controllerHome= Get.find();


  showRoute(context,route){


    List<Widget> pointsRoute=[];

    print("esta es la ruta  ${route}");

    var textShare="${route["name"]} \n\n";

    var imageMap=[];
    for(var i =0 ; i < route["puntos"].length; i ++){
      textShare=textShare+"${i+1} ${route["puntos"][i]["name"]}\n";
      if(i<2){
        imageMap.add("markers=size:mid|color:0xff0000|label:1|${route["puntos"][i]["localidad"].replaceAll(" ","+")}");

      }



      pointsRoute.add(Container(
        margin: EdgeInsets.only(bottom: 5),
        child: Text("${i+1} ${route["puntos"][i]["name"]}",style: TextStyle(fontSize: 15),),
      ));
    }
    if(route["puntos"].length==0){
      pointsRoute.add(Container(child: Text("Sin eventos",style: TextStyle(fontSize: 15),),));
    }

    var points=Uri.encodeComponent(imageMap.join("&"));
    var map="https://maps.googleapis.com/maps/api/staticmap?center=Bogota&zoom=13&scale=1&size=600x300&maptype=roadmap&key=AIzaSyA5nhS_u3MSsFPVmEtLJG3qCmv88p359Xc&format=png&visual_refresh=true&${points}";
    print("aquii esta  el mapa  ${map}");
    Alert(
        context: context,
        title: "${route["name"]}",
        content: Container(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: pointsRoute,
          ),
        ),
        buttons: [
          route["puntos"].length> 0 ? DialogButton(
            onPressed: () async {
              Share.share(
                  textShare,
                  subject: 'Mira mi ruta!');

              Navigator.pop(context);
            },
            child: Text(
              "Compartir",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ): DialogButton(
            color: Colors.black12,
            child: Text(
              "Compartir",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

addRoute(context){
  TextEditingController controllerName= TextEditingController();

  Alert(
      context: context,
      title: "Crea tu ruta",
      content: Column(
        children: <Widget>[
          TextField(
            controller: controllerName,
            decoration: InputDecoration(
               labelText: 'Nombre',
            ),
          ),

        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () async {
            SharedPreferences prefs =
                await SharedPreferences
                .getInstance();

            controllerHome.rutasApp.add({"name": controllerName.text, "puntos": []});
            controllerHome.rutasApp.refresh();

            prefs.setString(
                "rutas",
                jsonEncode(
                    controllerHome.rutasApp));


            Navigator.pop(context);
          },
          child: Text(
            "Crear",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]).show();
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        child: RaisedButton(
          onPressed: (){
            addRoute(context);
          },
          color: Colors.white,
          child: Text("Crear Ruta +"),
        ),
      ),
      appBar: AppBar(
        elevation: 0,

        centerTitle: true,
        title: Container(
          width: 100,

          child: Image.asset("assets/logobogotas.png"),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Obx(()=>ListView.builder(
            itemCount: controllerHome.rutasApp.length,
            itemBuilder: (BuildContext context,int index){
              return Container(
                child: RaisedButton(
                    onPressed: (){
                      showRoute(context,controllerHome.rutasApp[index]);
                    },
                    child: Text("${controllerHome.rutasApp[index]["name"]}")
                ),
              );
            }
        )),
      ),
    );
  }

}