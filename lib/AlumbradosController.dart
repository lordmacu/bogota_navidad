import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/date_symbol_data_local.dart';

class AlumbradosController extends GetxController {
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
    await rootBundle.loadString('assets/alumbrados.json');

    var jsonResult = json.decode(response);

    var placesFilterLocal = [];
    placesFilterLocal.add("Todos");

    for (var i = 0; i < jsonResult.length; i++) {





      var dateTime3 = DateFormat('dd MM yyyy', 'es_ES').parse("${jsonResult[i]["date_event_calendar"].replaceAll("-"," ")}");

      jsonResult[i]["fechaFormated"]=dateTime3;
      jsonResult[i]["fecha"]=jsonResult[i]["date_event_calendar"];
      jsonResult[i]["place"]=jsonResult[i]["evento"];
      jsonResult[i]["summary"]=jsonResult[i]["descripcion"];
      jsonResult[i]["card__image"]="https://cdn.colombia.com/sdi/2019/12/02/navidad-bogota-parque-el-tunal-novenas-de-aguinaldos-790403.webp";
      jsonResult[i]["addressComplete"]=jsonResult[i]["direccion"];
      jsonResult[i]["name"]=jsonResult[i]["titulo"];
      jsonResult[i]["card__localidad_2"]=jsonResult[i]["localidad"];


      placesFilterLocal.add(jsonResult[i]["localidad"]);


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



  @override
  void onInit() {
    dateTime.value=  DateTime.now();
    super.onInit();

    loadjsonData();

  }
}
