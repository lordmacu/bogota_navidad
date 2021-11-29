import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomeController extends GetxController {
  var jsonEvents = [].obs;
  var jsonEventsPrincipal = [].obs;
  var jsonEventsTemp = [].obs;
  var placesFilter = [].obs;

  var simpleEvento = 999.obs;
  var simpleEventoType = 0.obs;
  var allEventsSize = 0.obs;
  var filterButton = "Todos".obs;

  var contollerScroll= ScrollController().obs;

  var isCalendarShow=false.obs;
  var controllerPanel = PanelController().obs;
  var dateTime= DateTime(2021).obs;


  loadjsonData() async {
    final String response =
        await rootBundle.loadString('assets/events_general.json');

    var jsonResult = json.decode(response);

    var placesFilterLocal = [];
    placesFilterLocal.add("Todos");

    for (var i = 0; i < jsonResult.length; i++) {


      var fechaSimple=jsonResult[i]["fecha"].split(", ");
      var dateFormated=fechaSimple[1].replaceAll("de","").replaceAll("  "," ").replaceAll("diciembre","12");


      var dateTime3 = DateFormat('dd MM yyyy', 'es_ES').parse("${dateFormated} 2021");
      jsonResult[i]["fechaFormated"]=dateTime3;


      placesFilterLocal.add(jsonResult[i]["card__localidad_2"]);


    }
    placesFilter.assignAll(placesFilterLocal.toSet().toList());

    jsonEvents.assignAll(jsonResult);
    jsonEventsTemp.assignAll(jsonResult);
  }

  filterEvents( ) {


    if(filterButton.value!="Todos"){

      var jsonEventsLocal = [];
      for (var i = 0; i < jsonEventsTemp.length; i++) {
        if (jsonEventsTemp[i]["card__localidad_2"] == filterButton.value) {
          if(dateTime.value.difference(jsonEventsTemp[i]["fechaFormated"]).inDays == 0){
             jsonEventsLocal.add(jsonEventsTemp[i]);
          }
        }
      }

      allEventsSize.value=jsonEventsLocal.length;

      if(jsonEventsLocal.length==0){

        for (var i = 0; i < jsonEventsTemp.length; i++) {
          if (jsonEventsTemp[i]["card__localidad_2"] == filterButton.value) {

            if(dateTime.value.difference(jsonEventsTemp[i]["fechaFormated"]).inDays < 0){
              jsonEventsLocal.add(jsonEventsTemp[i]);
            }
          }
        }

      }

      jsonEvents.assignAll(jsonEventsLocal);

    }else{
      var jsonEventsLocal = [];

      for (var i = 0; i < jsonEventsTemp.length; i++) {
          if(dateTime.value.difference(jsonEventsTemp[i]["fechaFormated"]).inDays == 0){
            jsonEventsLocal.add(jsonEventsTemp[i]);
          }
      }

      allEventsSize.value=jsonEventsLocal.length;

      if(jsonEventsLocal.length==0){
        for (var i = 0; i < jsonEventsTemp.length; i++) {
          if(dateTime.value.difference(jsonEventsTemp[i]["fechaFormated"]).inDays > 0){
            jsonEventsLocal.add(jsonEventsTemp[i]);
          }
        }

        jsonEvents.assignAll(jsonEventsTemp);
      }else{
        jsonEvents.assignAll(jsonEventsLocal);
      }

    }

  }

  loadjsonDataPrincipal() async {
    initializeDateFormatting();

    final String response =
        await rootBundle.loadString('assets/events_principal.json');

    var jsonResult = json.decode(response);

    for (var i = 0; i < jsonResult.length; i++) {
      var fechaSimple=jsonResult[i]["fecha"].split(", ");
      var dateFormated=fechaSimple[1].replaceAll("de","").replaceAll("  "," ").replaceAll("diciembre","12");


      var dateTime3 = DateFormat('dd MM yyyy', 'es_ES').parse("${dateFormated} 2021");
      jsonResult[i]["fechaFormated"]=dateTime3;

    }

    print(jsonResult);

    jsonEventsPrincipal.assignAll(jsonResult);
  }

  @override
  void onInit() {
    dateTime.value=  DateTime.now();
    super.onInit();

    loadjsonData();
    loadjsonDataPrincipal();
  }
}
