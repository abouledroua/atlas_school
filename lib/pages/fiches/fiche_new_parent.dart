// ignore_for_file: avoid_print

import 'package:atlas_school/classes/data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class FicheNewParent extends StatefulWidget {
  const FicheNewParent({Key? key}) : super(key: key);

  @override
  _FicheNewParentState createState() => _FicheNewParentState();
}

class _FicheNewParentState extends State<FicheNewParent> {
  bool accept = false;
  String nom = "", prenom = "", dateNaiss = "";
  late int idParent, idUser;
  DateTime? date;
  int? sexe = 1;
  int currentStep = 0;
  TextEditingController txtNom = TextEditingController(text: "");
  TextEditingController txtPrenom = TextEditingController(text: "");
  TextEditingController txtDateNaiss = TextEditingController(text: "");
  TextEditingController txtAdresse = TextEditingController(text: "");
  TextEditingController txtTel1 = TextEditingController(text: "");
  TextEditingController txtTel2 = TextEditingController(text: "");
  bool loading = false,
      valider = false,
      upd = false,
      champsValid = false,
      _valNom = false,
      inscrit = false,
      _valPrenom = false;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    idParent = 0;
    idUser = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Data.setSizeScreen(context);
    return SafeArea(
        child: Stack(children: [
      Container(
          color: Colors.white,
          height: Data.heightScreen,
          width: Data.widthScreen),
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              height: Data.heightScreen,
              width: Data.widthScreen,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.15), BlendMode.dstATop),
                      image: const AssetImage('images/famille.jpg'))))),
      GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              drawer: Data.currentUser != null ? Data.myDrawer(context) : null,
              appBar: AppBar(
                  backgroundColor: Colors.amber,
                  centerTitle: true,
                  title: const FittedBox(child: Text("Nouveau Parent")),
                  leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white))),
              body: bodyContent()))
    ]));
  }

  existParent() async {
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/EXIST_PARENT.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {
          "NOM": txtNom.text,
          "PRENOM": txtPrenom.text,
          "DATE_NAISS": txtDateNaiss.text,
          "ID_PARENT": idParent.toString()
        })
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            switch (responsebody) {
              case 0:
                insertParent();
                break;
              case 1:
                setState(() {
                  valider = false;
                });
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    showCloseIcon: true,
                    title: 'Erreur',
                    desc: "Cet Parent existe déjà !!!");
                break;
              default:
            }
          } else {
            setState(() {
              valider = false;
            });
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
          setState(() {
            valider = false;
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

  insertParent() async {
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/INSERT_PARENT.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {
          "NOM": txtNom.text.toUpperCase(),
          "PRENOM": txtPrenom.text.toUpperCase(),
          "DATE_NAISS": txtDateNaiss.text,
          "ADRESSE": txtAdresse.text,
          "TEL1": txtTel1.text,
          "TEL2": txtTel2.text,
          "SEXE": sexe.toString()
        })
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var result = response.body;
            if (result != "0") {
              setState(() {
                inscrit = true;
              });
            } else {
              setState(() {
                valider = false;
              });
              AwesomeDialog(
                      context: context,
                      dialogType: DialogType.ERROR,
                      showCloseIcon: true,
                      title: 'Erreur',
                      desc: "Probleme lors de l'ajout !!!")
                  .show();
            }
          } else {
            setState(() {
              valider = false;
            });
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
          setState(() {
            valider = false;
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

  verifierChamps() {
    setState(() {
      _valNom = txtNom.text.isEmpty;
      _valPrenom = txtPrenom.text.isEmpty;
    });
  }

  bodyContent() {
    return Theme(
      data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.amber)),
      child: inscrit
          ? lastWidget()
          : Stepper(
              type: StepperType.horizontal,
              currentStep: currentStep,
              steps: getSteps(),
              onStepContinue: (currentStep == 1 && !accept)
                  ? null
                  : () {
                      switch (currentStep) {
                        case 0:
                          verifierChamps();
                          if (_valNom || _valPrenom) {
                            AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.ERROR,
                                    showCloseIcon: true,
                                    title: 'Erreur',
                                    desc:
                                        'Veuillez remplir tous les champs obligatoire !!!')
                                .show();
                          } else {
                            setState(() {
                              currentStep += 1;
                            });
                          }
                          break;
                        case 1:
                          setState(() {
                            currentStep += 1;
                          });
                          break;
                        case 2:
                          print("click on terminer");
                          setState(() {
                            valider = true;
                          });
                          existParent();
                          break;
                        default:
                      }
                    },
              onStepCancel: currentStep == 0
                  ? null
                  : () {
                      setState(() {
                        currentStep -= 1;
                      });
                    },
              controlsBuilder: (context, details) {
                return Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(children: [
                      Expanded(
                          child: ElevatedButton(
                              child: Text(details.currentStep == 2
                                  ? "Terminer"
                                  : "Suivant"),
                              onPressed: details.onStepContinue)),
                      const SizedBox(width: 10),
                      if (currentStep != 0)
                        Expanded(
                            child: Theme(
                          data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                  primary: Colors.grey)),
                          child: ElevatedButton(
                              child: const Text("Précedant"),
                              onPressed: details.onStepCancel),
                        ))
                    ]));
              }),
    );
  }

  lastWidget() =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Spacer(),
        Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            width: Data.widthScreen,
            child: const FittedBox(
                child: Text("Votre êtes Insris",
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        Container(
            padding: const EdgeInsets.all(10),
            width: Data.widthScreen,
            height: Data.heightScreen / 4,
            child: const FittedBox(
                child: Icon(Icons.cloud_done_outlined, color: Colors.green))),
        Container(
            margin: EdgeInsets.symmetric(vertical: Data.heightScreen / 20),
            padding: const EdgeInsets.only(left: 10, right: 10),
            width: Data.widthScreen,
            child: const FittedBox(
                child: Text("Veuillez Contacter l'administration de l'école",
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        const Spacer(),
        Theme(
            data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(primary: Colors.green)),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    width: Data.widthScreen / 2,
                    height: Data.heightScreen / 10,
                    child: const FittedBox(child: Text("Continuer"))))),
        const Spacer()
      ]);

  getSteps() => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 0,
            title: const Text('Informations'),
            content: step1()),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            title: const Text('Règles'),
            content: step2()),
        Step(
            isActive: currentStep >= 2,
            title: const Text('Confirmation'),
            content: step3())
      ];

  step1() => ListView(primary: false, shrinkWrap: true, children: [
        Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            child: TextField(
                enabled: !valider,
                controller: txtNom,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                    errorText: _valNom ? 'Champs Obligatoire' : null,
                    prefixIcon: const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.supervised_user_circle_outlined,
                            color: Colors.black)),
                    contentPadding: const EdgeInsets.only(bottom: 3),
                    labelText: "Nom",
                    labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    hintText: "Nom",
                    hintStyle:
                        const TextStyle(fontSize: 14, color: Colors.grey),
                    floatingLabelBehavior: FloatingLabelBehavior.always))),
        Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            child: TextField(
                enabled: !valider,
                controller: txtPrenom,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                    errorText: _valPrenom ? 'Champs Obligatoire' : null,
                    prefixIcon: const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.supervised_user_circle_outlined,
                            color: Colors.black)),
                    contentPadding: const EdgeInsets.only(bottom: 3),
                    labelText: "Prénom",
                    labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    hintText: "Prénom",
                    hintStyle:
                        const TextStyle(fontSize: 14, color: Colors.grey),
                    floatingLabelBehavior: FloatingLabelBehavior.always))),
        Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: TextField(
                enabled: !valider,
                onTap: () {
                  datePicker();
                },
                readOnly: true,
                controller: txtDateNaiss,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.datetime,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                    prefixIcon: const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.date_range_rounded,
                            color: Colors.black)),
                    suffixIcon: IconButton(
                        onPressed: () {
                          datePicker();
                        },
                        icon: const Icon(Icons.date_range_outlined)),
                    contentPadding: const EdgeInsets.only(bottom: 3),
                    labelText: "Date de Naissance",
                    labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    hintText: "Date de Naissance",
                    hintStyle:
                        const TextStyle(fontSize: 14, color: Colors.grey),
                    floatingLabelBehavior: FloatingLabelBehavior.always))),
        Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Sexe",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  const SizedBox(width: 25),
                  Radio(
                      groupValue: sexe,
                      value: 1,
                      onChanged: valider
                          ? null
                          : (value) {
                              setState(() {
                                sexe = value as int?;
                              });
                            }),
                  InkWell(
                      child: const Text("Homme"),
                      onTap: valider
                          ? null
                          : () {
                              setState(() {
                                sexe = 1;
                              });
                            }),
                  Radio(
                      groupValue: sexe,
                      value: 2,
                      onChanged: valider
                          ? null
                          : (value) {
                              setState(() {
                                sexe = value as int?;
                              });
                            }),
                  InkWell(
                      child: const Text("Femme"),
                      onTap: valider
                          ? null
                          : () {
                              setState(() {
                                sexe = 2;
                              });
                            })
                ])),
        Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            child: TextField(
                enabled: !valider,
                maxLines: null,
                controller: txtAdresse,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                decoration: const InputDecoration(
                    prefixIcon: Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.gps_fixed, color: Colors.blue)),
                    contentPadding: EdgeInsets.only(bottom: 3),
                    labelText: "Adresse",
                    labelStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    hintText: "Adresse",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    floatingLabelBehavior: FloatingLabelBehavior.always))),
        Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            child: TextField(
                enabled: !valider,
                maxLines: null,
                controller: txtTel1,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                decoration: const InputDecoration(
                    prefixIcon: Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.gps_fixed, color: Colors.blue)),
                    contentPadding: EdgeInsets.only(bottom: 3),
                    labelText: "Telephone 1",
                    labelStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    hintText: "Numero de Telephone 1",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    floatingLabelBehavior: FloatingLabelBehavior.always))),
        Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
                enabled: !valider,
                maxLines: null,
                controller: txtTel2,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                decoration: const InputDecoration(
                    prefixIcon: Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.gps_fixed, color: Colors.blue)),
                    contentPadding: EdgeInsets.only(bottom: 3),
                    labelText: "Telephone 2",
                    labelStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    hintText: "Numero de Telephone 2",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    floatingLabelBehavior: FloatingLabelBehavior.always)))
      ]);

  step2() => ListView(primary: false, shrinkWrap: true, children: [
        Center(
            child: FittedBox(
                child: Text("Règles d'utilisation de l'application",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: GoogleFonts.laila(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 100)))),
        const Divider(),
        const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                "Veuillez lire et accepter les termes d'utilisation de l'application ATLAS SCHOOL",
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic))),
        const Divider(),
        privacyText(),
        const Divider(),
        InkWell(
            onTap: () {
              setState(() {
                accept = !accept;
              });
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Switch(
                  value: accept,
                  onChanged: (value) {
                    setState(() {
                      accept = value;
                    });
                  }),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(children: const [
                    Text("J'accepte les terme d'utilisation",
                        overflow: TextOverflow.clip)
                  ]))
            ])),
        const SizedBox(height: 20)
      ]);

  step3() => valider
      ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
                Text("Validation en cours ...."),
                SizedBox(width: 15),
                CircularProgressIndicator.adaptive()
              ])
            ])
      : ListView(primary: false, shrinkWrap: true, children: [
          Row(children: [
            const Expanded(
                child: Text("Nom : ",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(flex: 2, child: Text(txtNom.text))
          ]),
          const SizedBox(height: 10),
          Row(children: [
            const Expanded(
                child: Text("Prénom : ",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(flex: 2, child: Text(txtPrenom.text))
          ]),
          const SizedBox(height: 10),
          if (txtDateNaiss.text.isNotEmpty)
            Row(children: [
              const Expanded(
                  child: Text("Date Naissance : ",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Text(txtDateNaiss.text))
            ]),
          const SizedBox(height: 10),
          if (txtAdresse.text.isNotEmpty)
            Row(children: [
              const Expanded(
                  child: Text("Adresse : ",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Text(txtAdresse.text))
            ]),
          const SizedBox(height: 10),
          if (txtTel1.text.isNotEmpty)
            Row(children: [
              const Expanded(
                  child: Text("Téléphone 1 : ",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Text(txtTel1.text))
            ]),
          const SizedBox(height: 10),
          if (txtTel2.text.isNotEmpty)
            Row(children: [
              const Expanded(
                  child: Text("Téléphone 2 : ",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Text(txtTel2.text))
            ])
        ]);

  title(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  details(String text) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  privacyText() {
    return ListView(shrinkWrap: true, primary: false, children: [
      title("Privacy Policy Introduction"),
      details(
          "    Our privacy policy will help you understand what information we collect at ATLAS SCHOOL, how ATLAS SCHOOL uses it, and what choices you have. ATLAS SCHOOL built the ATLAS SCHOOL app as a free app. This SERVICE is provided by ATLAS SCHOOL at no cost and is intended for use as is. If you choose to use our Service, then you agree to the collection and use of information in relation with this policy. The Personal Information that we collect are used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy. The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible in our website, unless otherwise defined in this Privacy Policy."),
      title("Information Collection and Use"),
      details(
          "    For a better experience while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to users name, email, address, pictures, function. The information that we request will be retained by us and used as described in this privacy policy. The app does use third party services that may collect information used to identify you."),
      title("Cookies"),
      details(
          "    Cookies are files with small amount of data that is commonly used an anonymous unique identifier. These are sent to your browser from the website that you visit and are stored on your devices’s internal memory. \n This Services does not uses these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collection information and to improve their services. You have the option to either accept or refuse these cookies, and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service."),
      title("Device Information"),
      details(
          "    We collect information from your device in some cases. The information will be utilized for the provision of better service and to prevent fraudulent acts. Additionally, such information will not include that which will identify the individual user."),
      title("Service Providers"),
      details(
          "    We may employ third-party companies and individuals due to the following reasons:\n    To facilitate our Service; To provide the Service on our behalf; To perform Service-related services; or To assist us in analyzing how our Service is used.\n    We want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose."),
      title("Security"),
      details(
          "    We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security."),
      title("Children’s Privacy"),
      details(
          "    This Services do not address anyone under the age of 13. We do not knowingly collect personal identifiable information from children under 13. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do necessary actions."),
      title("Changes to This Privacy Policy"),
      details(
          "    We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately, after they are posted on this page."),
      title("Contact Us"),
      details(
          "    If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us. Contact Information: Email: amor.bouledroua@live.fr")
    ]);
  }

  datePicker() {
    showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime(1800),
            lastDate: DateTime.now())
        .then((value) {
      date = value;
      setState(() {
        txtDateNaiss.text = DateFormat('yyyy-MM-dd').format(date!);
      });
    });
  }
}
