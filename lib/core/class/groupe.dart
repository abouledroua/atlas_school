import 'package:azlistview/azlistview.dart';

class Groupe extends ISuspensionBean {
  String designation;
  int id, etat;
  Groupe({required this.id, required this.designation, required this.etat});
  @override
  String getSuspensionTag() => designation[0].toUpperCase();
}
