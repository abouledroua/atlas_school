import 'package:azlistview/azlistview.dart';

class Enseignant extends ISuspensionBean {
  String nom,
      prenom,
      fullName,
      dateNaiss,
      adresse,
      tel1,
      matiere,
      userName,
      password;
  int id, sexe, idUser, etat;
  bool isHomme, isFemme;
  Enseignant(
      {required this.id,
      required this.nom,
      required this.prenom,
      required this.fullName,
      required this.etat,
      required this.password,
      required this.userName,
      required this.idUser,
      required this.isHomme,
      required this.isFemme,
      required this.dateNaiss,
      required this.adresse,
      required this.sexe,
      required this.matiere,
      required this.tel1});

  @override
  String getSuspensionTag() => fullName[0].toUpperCase();
}
