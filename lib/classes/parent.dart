import 'package:azlistview/azlistview.dart';

class Parent extends ISuspensionBean {
  String nom,
      prenom,
      fullName,
      dateNaiss,
      adresse,
      tel1,
      tel2,
      userName,
      password;
  int id, sexe, idUser,etat;
  bool isHomme, isFemme;
  Parent(
      {required this.id,
      required this.nom,
      required this.prenom,
      required this.fullName,
      required this.password,
      required this.userName,
      required this.etat,
      required this.idUser,
      required this.isHomme,
      required this.isFemme,
      required this.dateNaiss,
      required this.adresse,
      required this.sexe,
      required this.tel2,
      required this.tel1});

  @override
  String getSuspensionTag() => fullName[0].toUpperCase();
}
