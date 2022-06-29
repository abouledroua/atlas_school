// ignore_for_file: avoid_print

import 'package:atlas_school/core/class/enfant.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataServices extends GetxService {
  bool errorAdmin = false,
      loadingAdmin = false,
      errorEnfant = false,
      loadingEnfant = false;
  int adminId = 0;
  List<Enfant> enfants = [];

  Future<DataServices> init() async {
    if (!User.isAdmin) getAdminUser();
    if (User.isParent) getListEnfant();
    return this;
  }

  getListEnfant() async {
    errorEnfant = false;
    loadingEnfant = true;
    enfants.clear();
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_ENFANT_PARENT.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_PARENT": User.idParent.toString()})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Enfant e;
            late int sexe;
            for (var m in responsebody) {
              sexe = int.parse(m['SEXE']);
              e = Enfant(
                  nom: m['NOM'],
                  prenom: m['PRENOM'],
                  fullName: m['NOM'] + "  " + m['PRENOM'],
                  dateNaiss: m['DATE_NAISS'],
                  id: int.parse(m['ID_ENFANT']),
                  etat: int.parse(m['ETAT']),
                  sexe: sexe,
                  adresse: m['ADRESSE'],
                  photo: m['PHOTO'],
                  isHomme: (sexe == 1),
                  isFemme: (sexe == 2));
              enfants.add(e);
            }
            print("tous les enfants de ce parents ont été chargées ....");
          } else {
            errorEnfant = true;
            enfants.clear();
          }
          loadingEnfant = false;
        })
        .catchError((error) {
          print("erreur : $error");
          errorEnfant = true;
          enfants.clear();
          loadingEnfant = false;
        });
  }

  getAdminUser() async {
    errorAdmin = false;
    loadingAdmin = true;
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_ADMIN.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            for (var m in responsebody) {
              adminId = int.parse(m['USER']);
            }
            print("IdAdmin à été chargées ....");
            loadingAdmin = false;
          } else {
            errorAdmin = true;
            loadingAdmin = false;
          }
        })
        .catchError((error) {
          print("erreur : $error");
          errorAdmin = true;
          loadingAdmin = false;
        });
  }
}
