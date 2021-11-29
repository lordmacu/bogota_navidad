import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navidad_bogota/HomeController.dart';

class CardList extends StatelessWidget{
  final HomeController controllerHome = Get.find();

  var item;
  var height;
  var index;
  CardList(this.item,this.height,this.index);
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        controllerHome.simpleEvento.value=index;

        controllerHome.controllerPanel.value.open();
        controllerHome.simpleEventoType.value=1;

      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,

            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                "${item["card__image"]}",
                fit: BoxFit.cover,
              ),
            ),
            height: (height*60)/100,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(


              decoration: BoxDecoration(

                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black12,
                      Colors.black54,
                      Colors.black87,
                    ],
                  ),
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(30),bottomLeft:  Radius.circular(30))
              ),

              child: Stack(
                children: [
                  Align(

                    child: Container(

                      child: Column(

                        children: [
                          Container(
                            child: Text("${item["fecha"]}",style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 15
                            ),),
                            margin: EdgeInsets.only(bottom: 5),
                          ),
                          Text("${item["name"]}",style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold
                          ),),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(child: Text("${item["place"]}",style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal
                                ),))
                              ],
                            ),
                          )
                        ],
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      padding: EdgeInsets.only(left: 25,right: 25,bottom: 20),
                    ),
                    alignment: Alignment.bottomLeft,
                  )
                ],
              ),
              padding: EdgeInsets.only(top: 40,bottom: 10),
              width: double.infinity,
              height: 350,
            ),
          )
        ],
      ),
    );
  }

}