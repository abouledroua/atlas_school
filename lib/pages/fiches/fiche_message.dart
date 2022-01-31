// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math';
import 'package:atlas_school/classes/data.dart';
import 'package:atlas_school/classes/fetch.dart';
import 'package:atlas_school/classes/message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FicheMessage extends StatefulWidget {
  final int idUser;
  final String parentName;
  const FicheMessage({Key? key, required this.idUser, required this.parentName})
      : super(key: key);

  @override
  _FicheMessageState createState() => _FicheMessageState();
}

List<Message> messages = [];

class _FicheMessageState extends State<FicheMessage> {
  late int idUser;
  late String parentName;
  bool loading = true, error = false;
  TextEditingController txtMsg = TextEditingController(text: "");
  final _controller = ScrollController();

  listenNewMessages() async {
    while (true) {
      if (!Fetch.newMessage) {
        await Future.delayed(const Duration(seconds: 2));
      } else {
        Fetch.newMessage = false;
        getMessages();
      }
    }
  }

  getMessages() async {
    setState(() {
      loading = true;
      error = false;
    });
    messages.clear();
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/GET_MESSAGES.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {
          "ID_USER": Data.currentUser!.idUser.toString(),
          "ID_OTHER": idUser.toString()
        })
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Message e;
            for (var m in responsebody) {
              e = Message(
                  sent: 1,
                  body: m['MSG'],
                  date: DateTime.parse(m['DATEMSG']),
                  idRecept: int.parse(m['ID_RECEPT']),
                  idMessage: int.parse(m['ID_MESSAGE']),
                  etat: int.parse(m['ETAT']),
                  idSend: int.parse(m['ID_SEND']));
              messages.add(e);
            }
            if (messages.isNotEmpty) {
              Timer(
                  const Duration(seconds: 1),
                  () => _controller.animateTo(
                      _controller.position.maxScrollExtent,
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn));
            }
          } else {
            setState(() {
              messages.clear();
              error = true;
            });
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    showCloseIcon: true,
                    title: 'Erreur',
                    desc: 'Probleme de Connexion avec le serveur !!!')
                .show();
          }
          setState(() {
            loading = false;
          });
        })
        .catchError((error) {
          print("erreur : $error");
          setState(() {
            messages.clear();
            loading = false;
            error = true;
          });
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  showCloseIcon: true,
                  title: 'Erreur',
                  desc: 'Probleme de Connexion avec le serveur !!!')
              .show();
        });
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    idUser = widget.idUser;
    parentName = widget.parentName;
    loading = true;
    getMessages();
    Fetch.newMessage = false;
    listenNewMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          drawer: Data.myDrawer(context),
          appBar: AppBar(
              elevation: 1,
              iconTheme: const IconThemeData(color: Colors.black),
              centerTitle: true,
              backgroundColor: Colors.white,
              title: Text(parentName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black, fontSize: 20)),
              leading: Navigator.of(context).canPop()
                  ? IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.black))
                  : null,
              actions: [
                IconButton(
                    onPressed: getMessages,
                    icon: const FaIcon(FontAwesomeIcons.sync,
                        color: Colors.white))
              ]),
          body: bodyContent()),
    ));
  }

  bodyContent() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Expanded(child: listMessage()),
          Visibility(
              visible: Data.currentUser!.msgBlock,
              child: Center(
                  child: Wrap(children: const [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text("Vous êtes bloqué par l'administration",
                        style: TextStyle(fontSize: 16, color: Colors.red)))
              ])),
              replacement: Row(children: [
                Flexible(
                    child: TextFormField(
                        maxLines: null,
                        controller: txtMsg,
                        keyboardType: TextInputType.multiline,
                        decoration:
                            const InputDecoration(hintText: "Message"))),
                const SizedBox(width: 10),
                IconButton(onPressed: sendMessage, icon: const Icon(Icons.send))
              ]))
        ]));
  }

  resendMsg(int i) {
    txtMsg.text = messages[i].body;
    messages.removeAt(i);
    sendMessage();
    Navigator.of(context).pop();
  }

  sendMessage() {
    if (txtMsg.text.isNotEmpty) {
      DateTime currentDate = DateTime.now();
      Message msg = Message(
          sent: 0,
          idMessage: 0,
          body: txtMsg.text,
          date: currentDate,
          etat: 1,
          idRecept: idUser,
          idSend: Data.currentUser!.idUser);
      messages.add(msg);
      setState(() {
        txtMsg.text = "";
      });
      insertMsg(msg, messages.indexOf(msg));
    }
  }

  insertMsg(Message msg, int i) async {
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/INSERT_MESSAGE.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {
          "ID_SEND": msg.idSend.toString(),
          "ID_RECEPT": msg.idRecept.toString(),
          "BODY": msg.body.toString()
        })
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var result = response.body;
            if (result != "0") {
              setState(() {
                messages[i].sent = 1;
                messages[i].idMessage = int.parse(result);
              });
            } else {
              setState(() {
                messages[i].sent = -1;
              });
              AwesomeDialog(
                      context: context,
                      dialogType: DialogType.ERROR,
                      showCloseIcon: true,
                      title: 'Erreur',
                      desc: "Probleme lors de l'envoi du message !!!")
                  .show();
            }
          } else {
            setState(() {
              messages[i].sent = -1;
            });
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    showCloseIcon: true,
                    title: 'Erreur',
                    desc: 'Probleme de Connexion avec le serveur 2!!!')
                .show();
          }
        })
        .catchError((error) {
          print("erreur : $error");
          setState(() {
            messages[i].sent = -1;
          });
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  showCloseIcon: true,
                  title: 'Erreur',
                  desc: 'Probleme de Connexion avec le serveur 1 !!!')
              .show();
        });
  }

  listMessage() {
    return Visibility(
        visible: loading,
        child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: CircularProgressIndicator(
                      color: Data.darkColor[
                          Random().nextInt(Data.darkColor.length - 1) + 1])),
              const Text("Chargement en cours ...")
            ])),
        replacement: Visibility(
            visible: messages.isEmpty,
            child: Container(
                color: Colors.white,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: Text(
                              error
                                  ? "Erreur de connexion !!!"
                                  : "Aucun Message !!!!",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: error ? Colors.red : Colors.green,
                                  fontWeight: FontWeight.bold))),
                      Visibility(
                          visible: error, child: const SizedBox(height: 10)),
                      Visibility(
                          visible: error,
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  onPrimary: Colors.white),
                              onPressed: getMessages,
                              icon: const FaIcon(FontAwesomeIcons.sync,
                                  color: Colors.white),
                              label: const Text("Actualiser")))
                    ])),
            replacement: ListView.builder(
                controller: _controller,
                primary: false,
                shrinkWrap: true,
                itemCount: messages.length,
                itemBuilder: (context, i) {
                  return Padding(
                      padding: const EdgeInsets.all(4),
                      child: Align(
                          alignment:
                              (messages[i].idSend == Data.currentUser!.idUser)
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: UnconstrainedBox(
                              child: Row(children: [
                            Visibility(
                                visible: (messages[i].idSend ==
                                        Data.currentUser!.idUser &&
                                    messages[i].sent < 1),
                                child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Center(
                                        child: (messages[i].sent == 0)
                                            ? CircularProgressIndicator(
                                                color: Data.darkColor[Random()
                                                        .nextInt(Data.darkColor
                                                                .length -
                                                            1) +
                                                    1])
                                            : InkWell(
                                                onTap: () {
                                                  _showModal(i);
                                                },
                                                child: Ink(
                                                    child: const Icon(
                                                        Icons.warning,
                                                        color: Colors.red)))))),
                            Visibility(
                                visible: (messages[i].idSend ==
                                        Data.currentUser!.idUser &&
                                    messages[i].sent < 1),
                                child: const SizedBox(width: 10)),
                            showMessage(i)
                          ]))));
                })));
  }

  showMessage(int i) {
    return Column(
        crossAxisAlignment: (messages[i].idSend == Data.currentUser!.idUser)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              _showModal(i);
            },
            child: Container(
                constraints: BoxConstraints(maxWidth: Data.widthScreen * 5 / 7),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: (messages[i].idSend == Data.currentUser!.idUser)
                        ? Colors.blue
                        : Colors.grey.shade600,
                    border: Border.all(color: Colors.grey),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(30.0))),
                child: Text(messages[i].body,
                    style: const TextStyle(color: Colors.white))),
          ),
          Text(Data.printDate(messages[i].date),
              style: const TextStyle(fontSize: 11))
        ]);
  }

  Widget makeDismissible({required Widget child}) => GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(onTap: () {}, child: child));

  _showModal(int i) async {
    showModalBottomSheet(
        context: context,
        elevation: 5,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          print(" messages[i].sent=${messages[i].sent}");
          const double textSize = 26;
          double initHeight = messages[i].sent == 1
              ? 120 / Data.heightScreen
              : 190 / Data.heightScreen;
          return makeDismissible(
              child: DraggableScrollableSheet(
                  initialChildSize: initHeight,
                  minChildSize: initHeight,
                  maxChildSize: 0.9,
                  builder: (_, controller) => Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(25))),
                      padding: const EdgeInsets.all(10),
                      child: ListView(controller: controller, children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: InkWell(
                                onTap: () {
                                  AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.QUESTION,
                                          showCloseIcon: true,
                                          title: 'Confirmation',
                                          btnOkText: "Oui",
                                          btnCancelText: "Non",
                                          btnOkOnPress: () {
                                            if (messages[i].sent == 1) {
                                              deleteMessage(i);
                                            } else {
                                              messages.removeAt(i);
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          btnCancelOnPress: () {
                                            Navigator.of(context).pop();
                                          },
                                          desc:
                                              'Voulez vraiment supprimer ce message ?')
                                      .show();
                                },
                                child: Ink(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                      Icon(Icons.delete,
                                          color: Colors.red, size: textSize),
                                      SizedBox(width: 10),
                                      Text("Supprimer",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: textSize))
                                    ])))),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: InkWell(
                                onTap: () {
                                  Clipboard.setData(
                                      ClipboardData(text: messages[i].body));
                                  Data.showSnack("Text copier", Colors.black);
                                  Navigator.of(context).pop();
                                },
                                child: Ink(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                      Icon(Icons.copy,
                                          color: Colors.black, size: textSize),
                                      SizedBox(width: 10),
                                      Text("Copier Texte",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: textSize))
                                    ])))),
                        Visibility(
                            visible: messages[i].sent != 1,
                            child: const Divider()),
                        Visibility(
                            visible: messages[i].sent != 1,
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: InkWell(
                                    onTap: () {
                                      AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.QUESTION,
                                              showCloseIcon: true,
                                              title: 'Confirmation',
                                              btnOkText: "Oui",
                                              btnCancelText: "Non",
                                              btnOkOnPress: () {
                                                resendMsg(i);
                                              },
                                              btnCancelOnPress: () {
                                                Navigator.of(context).pop();
                                              },
                                              desc:
                                                  'Voulez vraiment renvoyer ce message ?')
                                          .show();
                                    },
                                    child: Ink(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                          Icon(Icons.send,
                                              color: Colors.green,
                                              size: textSize),
                                          SizedBox(width: 10),
                                          Text("Renvoyer",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: textSize))
                                        ])))))
                      ]))));
        });
  }

  deleteMessage(int i) async {
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/DELETE_MESSAGE.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_MESSAGE": messages[i].idMessage.toString()})
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var result = response.body;
            if (result != "0") {
              Data.showSnack('Message supprimé ...', Colors.green);
              Navigator.of(context).pop();
              setState(() {
                messages.removeAt(i);
              });
            } else {
              AwesomeDialog(
                      context: context,
                      dialogType: DialogType.ERROR,
                      showCloseIcon: true,
                      title: 'Erreur',
                      desc: "Probleme lors de la suppression !!!")
                  .show();
            }
          } else {
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    showCloseIcon: true,
                    title: 'Erreur',
                    desc: 'Probleme de Connexion avec le serveur !!!')
                .show();
          }
        })
        .catchError((error) {
          print("erreur : $error");
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  showCloseIcon: true,
                  title: 'Erreur',
                  desc: 'Probleme de Connexion avec le serveur !!!')
              .show();
        });
  }
}
