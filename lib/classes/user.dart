class User {
  String username, password, parentName, parentPhone;
  bool isAdmin, isParent, isEns, msgBlock;
  int idUser, idParent, type, etat, idEns;
  User(
      {required this.username,
      required this.idParent,
      required this.idEns,
      required this.isAdmin,
      required this.isParent,
      required this.isEns,
      required this.msgBlock,
      required this.parentName,
      required this.password,
      required this.parentPhone,
      required this.type,
      required this.idUser,
      required this.etat});
}
