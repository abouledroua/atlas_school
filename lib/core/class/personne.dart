class Personne {
  String name, lastMsg;
  DateTime? date;
  bool isAdmin, newMsg;
  int idUser, idParent;
  Personne(
      {required this.name,
      required this.newMsg,
      required this.isAdmin,
      required this.lastMsg,
      required this.date,
      required this.idUser,
      required this.idParent});
}
