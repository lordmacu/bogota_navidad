import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:navidad_bogota/AlumbradosController.dart';
import 'package:navidad_bogota/HomeController.dart';
import 'package:get/get.dart';
import 'package:navidad_bogota/cardList.dart';
import 'package:navidad_bogota/cardListBottom.dart';
import 'package:navidad_bogota/cardListBottomAlumbrados.dart';
import 'package:navidad_bogota/rutas.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class Alumbrados extends StatelessWidget {
  final AlumbradosController controllerAlumbrados = Get.put(AlumbradosController());
  final HomeController controllerHome = Get.put(HomeController());

  void _launchMapsUrl(address) async {
    final url =
        'https://www.google.com/maps/dir//${Uri.encodeComponent(address)}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  findPoints(item, arrayPoint) {
    for (var i = 0; i < arrayPoint.length; i++) {
      if (item["fecha"] == arrayPoint[i]["date"] &&
          item["name"] == arrayPoint[i]["name"]) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(10.0), // here the desired height

        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,

        ),
      ),
      body: SlidingUpPanel(
        header: GestureDetector(
          onTap: () {
            controllerAlumbrados.controllerPanel.value.close();
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                Container(
                  width: width,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xff202834),
                              borderRadius: BorderRadius.circular(50)),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(right: 15, top: 15),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        controller: controllerAlumbrados.controllerPanel.value,
        maxHeight: height - 130,
        isDraggable: false,
        minHeight: 0,
        backdropEnabled: true,
        color: Color(0xff202834),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        panel: Container(
          child: Obx(() {
            var item = null;

            if (controllerAlumbrados.simpleEvento.value != 999) {
              if (controllerAlumbrados.simpleEventoType.value == 1) {
                item = controllerAlumbrados
                    .jsonEventsPrincipal[controllerAlumbrados.simpleEvento.value];
              } else {
                item = controllerAlumbrados
                    .jsonEvents[controllerAlumbrados.simpleEvento.value];
              }

              var summary = item["summary"].split("\n");

              var summaryArray = [];
              for (var i = 0; i < summary.length; i++) {
                summaryArray.add(summary[i].trim());
              }

              return SingleChildScrollView(

                child: Container(
                  child: controllerAlumbrados.simpleEvento.value != 999
                      ? Column(
                    children: [
                      Container(
                        height: 300,
                        child: CardList(item, height,
                            controllerAlumbrados.simpleEvento.value),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: RaisedButton(
                          onPressed: () async {
                            List<Widget> rutasButton = [];

                            for (var i = 0;
                            i < controllerHome.rutasApp.length;
                            i++) {
                              rutasButton.add(RaisedButton(
                                onPressed: () async {
                                  var checkIfExist = findPoints(
                                      item,
                                      controllerHome.rutasApp[i]
                                      ["puntos"]);
                                  if (!checkIfExist) {
                                    controllerHome.rutasApp[i]["puntos"]
                                        .add({
                                      "name": item["name"],
                                      "address": item["addressComplete"],
                                      "date": item["fecha"],
                                      "localidad": item["card__localidad_2"]
                                    });
                                    SharedPreferences prefs =
                                    await SharedPreferences
                                        .getInstance();

                                    prefs.setString(
                                        "rutas",
                                        jsonEncode(
                                            controllerHome.rutasApp));

                                    Toast.show(
                                        "Evento agregado correctamente",
                                        context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM,
                                        backgroundColor:
                                        Colors.greenAccent,
                                        textColor: Colors.black87);
                                  } else {
                                    Toast.show(
                                        "Evento agregado previamente",
                                        context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM,
                                        backgroundColor:
                                        Colors.redAccent);
                                  }

                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                        child: Text(
                                          "${controllerHome.rutasApp[i]["name"]} +",
                                          style: TextStyle(fontSize: 20),
                                          textAlign: TextAlign.center,
                                        )),
                                  ],
                                ),
                              ));
                            }

                            Alert(
                              style: AlertStyle(
                                  backgroundColor: Color(0xff202834),
                                  titleStyle:
                                  TextStyle(color: Colors.white),
                                  descStyle:
                                  TextStyle(color: Colors.white)),
                              context: context,
                              type: AlertType.none,
                              title: "Mis rutas",
                              content: Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Column(
                                  children: rutasButton,
                                ),
                              ),
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "Crear una ruta",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20),
                                  ),
                                  onPressed: (){

                                    Get.to(() => Rutas());

                                  },
                                  color: Colors.white,
                                )
                              ],
                            ).show();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Agregar a mi ruta +",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin:
                        EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            RaisedButton(
                              onPressed: () {
                                _launchMapsUrl(item["addressComplete"]);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Como Llegar",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                Share.share(
                                    'Te invito al siguiente evento: ${item["name"]} nos vemos en ${item["place"]} ${item["card__image"]}',
                                    subject: 'Mira lo que encontré!');
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Compartir",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "${summaryArray.join("\n \n")}",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ],
                  )
                      : Container(),
                ),
              );
            } else {
              return Container();
            }
          }),
        ),
        body: Column(
          children: [
            Expanded(
                child: Container(
                  child: Obx(() => ListView.builder(
                      padding: EdgeInsets.only(bottom: 100),
                      itemCount: controllerAlumbrados.jsonEvents.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Stack(
                                  children: [

                                    Container(

                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(

                                                child:  Container(
                                                  color: Colors.transparent,

                                                  child: Icon(Icons.arrow_back_ios_sharp,color: Colors.white,),
                                                  padding: EdgeInsets.all(10),
                                                ),
                                                onTap: (){
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10,left: 10),
                                                width: 100,
                                                child: Image.asset("assets/logobogotas.png"),
                                              )
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 15),

                                            child: RaisedButton(onPressed: (){
                                              Get.to(() => Rutas());
                                            },child: Text("Mis Rutas"),
                                              color: Colors.white,),
                                          )
                                        ],
                                      ),
                                      padding: EdgeInsets.only(left: 0,right: 20),
                                    ),

                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 20,top: 20),
                                child: Row(
                                  children: [
                                    Text(
                                      "Alumbrados en Bogotá",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 27),
                                    ),

                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                ),
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 20, top: 20),
                              ),

                              Container(
                                margin: EdgeInsets.only(bottom: 30),
                                height: 50.0,
                                child: ListView.builder(
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controllerAlumbrados.placesFilter.length,
                                  itemBuilder:
                                      (BuildContext context, int indexdf) =>
                                      Container(
                                        child: RaisedButton(
                                          onPressed: () {
                                            controllerAlumbrados.filterButton.value=controllerAlumbrados.placesFilter[indexdf];
                                            controllerAlumbrados.filterEvents();
                                          },
                                          child: Text(
                                            "${controllerAlumbrados.placesFilter[indexdf]}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        padding: EdgeInsets.only(left: 7, right: 7),
                                      ),
                                ),
                              ),
                              Obx(() => Container(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: <Widget>[
                                    DatePicker(
                                      DateTime.now(),
                                      initialSelectedDate:
                                      controllerAlumbrados.dateTime.value,
                                      selectionColor: Color(0xfff8ac23),
                                      deactivatedColor: Colors.white,
                                      locale: "es_ES",
                                      height: 90,
                                      dateTextStyle: TextStyle(
                                          color: Colors.white),
                                      dayTextStyle: TextStyle(
                                          color: Colors.white),
                                      monthTextStyle: TextStyle(
                                          color: Colors.white),
                                      selectedTextColor: Colors.white,
                                      onDateChange: (date) {
                                        controllerAlumbrados.dateTime.value=date;
                                        controllerAlumbrados.filterEvents();
                                      },
                                    ),
                                  ],
                                ),
                                margin: EdgeInsets.only(bottom: 30),
                              )),
                              Obx(()=>Container(
                                padding: EdgeInsets.only(left: 20,right: 20),

                                child:controllerAlumbrados.allEventsSize.value==0 ? Container(

                                  child: Row(

                                    children: [
                                      Expanded(child: Text("No hay eventos en ${controllerAlumbrados.filterButton.value} para este dia.. pero puedes ver estos otros",textAlign: TextAlign.center,)),
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  ),
                                  margin: EdgeInsets.only(bottom: 20),
                                ): Container(),
                              )),

                              Container(
                                padding:
                                EdgeInsets.only(left: 20, right: 20, top: 0),
                                child: CardListBottomAlumbrados(
                                    controllerAlumbrados.jsonEvents[index],
                                    height,
                                    index),
                              )
                            ],
                          );
                        }
                        return Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: CardListBottomAlumbrados(
                              controllerAlumbrados.jsonEvents[index], height, index),
                        );
                      })),
                ))
          ],
        ),
      ),
    );
  }
}
