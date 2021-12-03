import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navidad_bogota/AlumbradosController.dart';
import 'package:navidad_bogota/HomeController.dart';

class CardListBottomAlumbrados extends StatelessWidget{
  final AlumbradosController controllerAlumbrados = Get.find();

  var item;
  var height;
  var index;

  CardListBottomAlumbrados(this.item,this.height,this.index);
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        controllerAlumbrados.simpleEvento.value=index;
        controllerAlumbrados.controllerPanel.value.open();
        controllerAlumbrados.simpleEventoType.value=2;

      },
      child:  Container(
        margin: EdgeInsets.only(bottom: 20),

        child: Stack(
          children: [
            Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    "${item["card__image"]}",
                    fit: BoxFit.cover,
                  ),
                ),
                width: double.infinity
            ),
            Align(

              child: Container(
                child: null,
                height: 150,
                decoration: BoxDecoration(

                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black12,
                        Colors.black54,
                        Colors.black87,
                      ],
                    ),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft:  Radius.circular(30))
                ),
              ),
              alignment: Alignment.topCenter,
            ),
            Align(

              child: Container(
                child: null,
                height: 200,
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
              ),
              alignment: Alignment.bottomCenter,
            ),
            Align(
              alignment: Alignment.topRight,
              child:Container(
                margin: EdgeInsets.only(right: 15,top: 10),
                child: Text("${item["place"]}",style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400
                ),),
              ) ,
            ),
            Align(

              child: Container(

                child: Column(

                  children: [
                    Container(
                      child: Row(

                        children: [
                          Text("${item["fecha"]}",style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 15
                          ),),

                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                      margin: EdgeInsets.only(bottom: 5),
                    ),
                    Row(
                      children: [
                        Expanded(child: Text("${item["name"]}",style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),))
                      ],
                    ),

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
        width: double.infinity,

        height: 200,
      ),
    );
  }

}