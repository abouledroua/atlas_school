class Message {
  String body;
  int idSend, idRecept, etat, sent, idMessage;
  DateTime date;
  Message(
      {required this.body,
      required this.idMessage,
      required this.date,
      required this.sent,
      required this.idSend,
      required this.idRecept,
      required this.etat});
}
