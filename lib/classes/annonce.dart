import 'package:atlas_school/classes/enfant.dart';
import 'package:atlas_school/classes/groupe.dart';
import 'package:atlas_school/classes/parent.dart';

class Annonce {
  String titre, detail, date, heure;
  int id, etat, visiblite;
  DateTime dateTime;
  List<String> images, strGroupes, strParents, strEnfants;
  List<Groupe> groupes = [];
  List<Enfant> enfants = [];
  List<Parent> parents = [];
  bool pin;
  Annonce(
      {required this.id,
      required this.pin,
      required this.dateTime,
      required this.images,
      required this.visiblite,
      required this.strParents,
      required this.strEnfants,
      required this.strGroupes,
      required this.titre,
      required this.detail,
      required this.date,
      required this.heure,
      required this.etat});
}
