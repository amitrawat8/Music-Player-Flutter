import 'package:flutter/material.dart';
import 'package:musicplayerdemo/src/constant/base_color_values.dart';
import 'package:musicplayerdemo/src/constant/base_constant.dart';
import 'package:musicplayerdemo/src/util/style_font.dart';

// Created by Amit Rawat
class AlertHandler {
  static TextStyle headGreyText = StyleFonts.fontstyle(
      14.0, FontWeight.w500, BaseColorValue.BackgroundColor);
  static TextStyle greyText = StyleFonts.fontstyle(
      12.0, FontWeight.w500, BaseColorValue.GreyPrimaryW400);
  static TextStyle buttonText =
      StyleFonts.fontstyle(12.0, FontWeight.w600, BaseColorValue.BLUE_COLOR);

  /*server side error msg */
  static  showAlert(
      BuildContext context, String msg, String tag) {
    Icon imageurl;
    switch (tag) {
      case BaseConstant.KEY_INTERNET:
        imageurl = new Icon(Icons.wifi_off);
        break;
      case BaseConstant.KEY_INFO:
        imageurl = new Icon(Icons.info);
        break;
      case BaseConstant.KEY_SERVER:
        imageurl = new Icon(Icons.all_inbox);
        break;
      default:
        imageurl = new Icon(Icons.info);
        break;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(5.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: new Center(
              child: new IconButton(
                padding: EdgeInsets.zero,
                icon: imageurl,
                color: Colors.green,
                iconSize: 40,
                onPressed: () {},
              ),
            ),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                msg,
                style: headGreyText,
              ),
            ]),
            actions: <Widget>[
              TextButton(
                child: Text(BaseConstant.KEY_OK, style: buttonText),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
