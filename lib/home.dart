import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:navidad_bogota/HomeController.dart';
import 'package:get/get.dart';
import 'package:navidad_bogota/cardList.dart';
import 'package:navidad_bogota/cardListBottom.dart';
import 'package:share/share.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class Home extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(

            child:  Obx(()=>FloatingActionButton(
              backgroundColor: Color(0xfff8ac23),

              onPressed: () {
                controllerHome.isCalendarShow.value =
                !controllerHome.isCalendarShow.value;
                controllerHome.dateTime.value=  DateTime.now();
                controllerHome.filterButton.value="Todos";


              },
              child: Container(
                margin: EdgeInsets.only(top: 7),
                width: 38,
                child: Stack(
                  children: [
                    Align(
                      child: Container(
                        child: Text(
                          "${controllerHome.dateTime.value.day}",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                       ),
                      alignment: Alignment.center,
                    ),
                    Image.asset("assets/lococalendar.png"),
                  ],
                ),
              ),
            )),
          )
        ],
      ),
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
            controllerHome.controllerPanel.value.close();
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
        controller: controllerHome.controllerPanel.value,
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

            if (controllerHome.simpleEvento.value != 999) {
              if (controllerHome.simpleEventoType.value == 1) {
                item = controllerHome
                    .jsonEventsPrincipal[controllerHome.simpleEvento.value];
              } else {
                item = controllerHome
                    .jsonEvents[controllerHome.simpleEvento.value];
              }

              var summary = item["summary"].split("\n");

              var summaryArray = [];
              for (var i = 0; i < summary.length; i++) {
                summaryArray.add(summary[i].trim());
              }

              return SingleChildScrollView(

                child: Container(
                  child: controllerHome.simpleEvento.value != 999
                      ? Column(
                          children: [
                            Container(
                              height: 300,
                              child: CardList(item, height,
                                  controllerHome.simpleEvento.value),
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
                  itemCount: controllerHome.jsonEvents.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                width: 100,
                                child: Image.asset("assets/logobogotas.png"),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Obx(()=>Text(
                                  !controllerHome.isCalendarShow.value ? "Eventos Principales" : "Eventos del mes",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                )),

                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 20, top: 20),
                          ),
                          Obx(()=>!controllerHome.isCalendarShow.value ? Container(
                            child: Obx(() => Swiper(
                              itemBuilder:
                                  (BuildContext context, int indexd) {
                                return Container(
                                    padding:
                                    EdgeInsets.only(left: 5, right: 5),
                                    child: CardList(
                                        controllerHome
                                            .jsonEventsPrincipal[indexd],
                                        height,
                                        indexd));
                              },
                              itemCount:
                              controllerHome.jsonEventsPrincipal.length,
                              viewportFraction: 0.8,
                              scale: 0.9,
                            )),
                            padding: EdgeInsets.only(bottom: 30),
                            height: (height * 50) / 100,
                          ): Container()),
                          Container(
                            margin: EdgeInsets.only(bottom: 30),
                            height: 50.0,
                            child: ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: controllerHome.placesFilter.length,
                              itemBuilder:
                                  (BuildContext context, int indexdf) =>
                                      Container(
                                child: RaisedButton(
                                  onPressed: () {
                                    controllerHome.filterButton.value=controllerHome.placesFilter[indexdf];
                                    controllerHome.filterEvents();
                                  },
                                  child: Text(
                                    "${controllerHome.placesFilter[indexdf]}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                padding: EdgeInsets.only(left: 7, right: 7),
                              ),
                            ),
                          ),
                          Obx(() => AnimatedOpacity(
                                opacity:
                                    controllerHome.isCalendarShow.value ? 1 : 0,
                                duration: Duration(seconds: 1),
                                child: controllerHome.isCalendarShow.value
                                    ? Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            DatePicker(
                                              DateTime.now(),
                                              initialSelectedDate:
                                              controllerHome.dateTime.value,
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
                                                controllerHome.dateTime.value=date;
                                                controllerHome.filterEvents();
                                              },
                                            ),
                                          ],
                                        ),
                                        margin: EdgeInsets.only(bottom: 30),
                                      )
                                    : Container(),
                              )),
                          Obx(()=>Container(
                            padding: EdgeInsets.only(left: 20,right: 20),

                            child:controllerHome.allEventsSize.value==0 ? Container(

                              child: Row(

                                children: [
                                  Expanded(child: Text("No hay eventos en ${controllerHome.filterButton.value} para este dia.. pero puedes ver estos otros",textAlign: TextAlign.center,)),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              margin: EdgeInsets.only(bottom: 20),
                            ): Container(),
                          )),

                          Container(
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 0),
                            child: CardListBottom(
                                controllerHome.jsonEvents[index],
                                height,
                                index),
                          )
                        ],
                      );
                    }
                    return Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: CardListBottom(
                          controllerHome.jsonEvents[index], height, index),
                    );
                  })),
            ))
          ],
        ),
      ),
    );
  }
}
