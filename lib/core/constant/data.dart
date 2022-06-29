// ignore_for_file: avoid_print

import 'package:atlas_school/core/class/annonce.dart';
import 'package:atlas_school/core/class/photo.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/services/settingservice.dart';
import 'package:atlas_school/view/screen/photoview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppData {
  static String www = "ATLAS", serverIP = "atlasschool.dz";
  static int timeOut = 8;

  static String getServerIP() => serverIP;

  static int getTimeOut() => timeOut;

  static String getServerDirectory([port = ""]) => ((serverIP == "")
      ? ""
      : "https://$serverIP" + (port != "" ? ":" + port : "") + "/" + www);

  static String getImage(pImage, pType) =>
      getServerDirectory() + "/IMAGE/$pType/$pImage";

  static setServerIP(ip) async {
    serverIP = ip;
    SettingServices c = Get.find();
    c.sharedPrefs.setString('ServerIp', serverIP);
  }

  static mySnackBar({required title, required message, required color}) =>
      Get.snackbar(title, message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: color,
          colorText: AppColor.white);

  static String printDate(DateTime? date) {
    DateTime currentDate = DateTime.now();
    int yy = currentDate.year - date!.year;
    String str = "";
    if (yy > 0) {
      str = DateFormat('yyyy-MM-dd').format(date);
    } else {
      int mm = currentDate.month - date.month;
      int dd = currentDate.day - date.day;
      int hh = currentDate.hour - date.hour;
      int min = currentDate.minute - date.minute;
      if (mm < 0) {
        yy--;
        mm += 12;
      }
      if (dd < 0) {
        mm--;
        dd += 30;
      }
      if (hh < 0) {
        dd--;
        hh += 24;
      }
      if (min < 0) {
        hh--;
        min += 60;
      }
      if (dd > 6) {
        str = DateFormat('dd MMM à HH:mm').format(date);
      } else {
        String ch = "";
        switch (dd) {
          case 0:
            if (hh > 0) {
              ch = "0" + hh.toString();
              ch = ch.substring(ch.length - 2);
              str = "Il y'a " + ch + " heure(s)";
            } else {
              if (min > 0) {
                ch = "0" + min.toString();
                ch = ch.substring(ch.length - 2);
                str = "Il y'a " + ch + " minute(s)";
              } else {
                str = "Il y a un instant";
              }
            }
            break;
          case 1:
            str = "Hier " + DateFormat('HH:mm').format(date);
            break;
          default:
            str = DateFormat('EEE à HH:mm').format(date);
            break;
        }
      }
    }
    return str;
  }

  static showImage(Annonce annonce, int i) => InkWell(
      onTap: () async {
        List<Photo> gallery = [];
        for (var item in annonce.images) {
          gallery.add(Photo(chemin: item, date: '', heure: '', id: 0));
        }
        Get.to(PhotoViewPage(
            index: i, folder: "ANNONCE", myImages: gallery, delete: false));
      },
      child: Center(
          child: Ink(
              padding: const EdgeInsets.all(2),
              child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  imageUrl: AppData.getImage(annonce.images[i], "ANNONCE"),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator()))));
}
