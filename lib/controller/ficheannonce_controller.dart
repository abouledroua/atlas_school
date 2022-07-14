// ignore_for_file: avoid_print

import 'dart:io';
import 'package:atlas_school/core/class/enfant.dart';
import 'package:atlas_school/core/class/gest_annonce_images.dart';
import 'package:atlas_school/core/class/groupe.dart';
import 'package:atlas_school/core/class/image_annonce.dart';
import 'package:atlas_school/core/class/myannonceimage.dart';
import 'package:atlas_school/core/class/parent.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/screen/listenfantselect.dart';
import 'package:atlas_school/view/screen/listgroupeselect.dart';
import 'package:atlas_school/view/screen/listparentselect.dart';
import 'package:atlas_school/view/widget/selectcameragellerywidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FicheAnnonceController extends GetxController {
  late int idAnnonce;
  List<Groupe> groupes = [];
  List<Parent> parents = [];
  List<Enfant> enfants = [];
  bool valider = false,
      loadingSub = false,
      loading = false,
      error = false,
      valTitre = false;
  int nbAnnImg = 0, visibiliteMode = 1;
  late TextEditingController titreController, detailsController;
  List<MyAnnonceImage> myImages = [];
  List<int> deletedImages = [];
  String radio = "Public";

  FicheAnnonceController(int id) {
    idAnnonce = id;
  }

  setValider(pValue) {
    valider = pValue;
    update();
  }

  updateRadio(newValue) {
    radio = newValue;
    update();
  }

  saveAnnonce() {
    setValider(true);
    valTitre = titreController.text.isEmpty;
    if (valTitre) {
      setValider(false);
      print("Veuillez saisir le titre de l'annonce !!!!");
      AppData.mySnackBar(
          color: AppColor.red,
          title: 'Fiche Annonce',
          message: "Veuillez saisir le titre de l'annonce !!!!");
    } else {
      if ((visibiliteMode == 2 && groupes.isEmpty) ||
          (visibiliteMode == 3 && parents.isEmpty) ||
          (visibiliteMode == 4 && enfants.isEmpty)) {
        AppData.mySnackBar(
            color: AppColor.red,
            title: 'Fiche Annonce',
            message:
                "Veuillez régler les paramêtres de visibilité de l'annonce !!!");
      } else {
        existAnnonce();
      }
    }
  }

  existAnnonce() async {
    setValider(true);
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/EXIST_ANNONCE.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {
          "TITRE": titreController.text,
          "ID_ANNONCE": idAnnonce.toString(),
        })
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            int result = 0;
            for (var m in responsebody) {
              result = int.parse(m['ID_ANNONCE']);
            }
            if (result == 0) {
              if (idAnnonce == 0) {
                print(
                    "annonce n'existe pas dans la bdd en cours de l'ajout ...");
                insertAnnonce();
              } else {
                print(
                    "annonce n'existe pas dans la bdd en cours de la modification ...");
                updateAnnonce();
              }
            } else {
              setValider(false);
              AppData.mySnackBar(
                  title: 'Fiche Annonce',
                  message: "Il existe déjà une annonce avec ce même titre !!!",
                  color: AppColor.red);
            }
          } else {
            setValider(false);
            AppData.mySnackBar(
                title: 'Fiche Annonce',
                message: "Probleme de Connexion avec le serveur 9!!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          print("erreur : $error");
          setValider(false);
          AppData.mySnackBar(
              title: 'Fiche Annonce',
              message: "Probleme de Connexion avec le serveur 9!!!",
              color: AppColor.red);
        });
  }

  insertAnnonce() async {
    String serverDir = AppData.getServerDirectory();
    String pGroupe = "", pParent = "", pEnfant = "";
    if (visibiliteMode == 2) {
      for (var i = 0; i < groupes.length; i++) {
        if (pGroupe.isNotEmpty) {
          pGroupe += ",";
        }
        pGroupe += groupes[i].id.toString();
      }
    } else if (visibiliteMode == 3) {
      for (var i = 0; i < parents.length; i++) {
        if (pParent.isNotEmpty) {
          pParent += ",";
        }
        pParent += parents[i].id.toString();
      }
    } else if (visibiliteMode == 4) {
      for (var i = 0; i < enfants.length; i++) {
        if (pEnfant.isNotEmpty) {
          pEnfant += ",";
        }
        pEnfant += enfants[i].id.toString();
      }
    }
    var body = {};
    body['TITRE'] = titreController.text;
    body['DETAILS'] = detailsController.text;
    body['TYPE'] = visibiliteMode.toString();
    body['GROUPES'] = pGroupe;
    body['PARENTS'] = pParent;
    body['ENFANTS'] = pEnfant;
    var url = "$serverDir/INSERT_ANNONCE.php";
    Uri myUri = Uri.parse(url);
    http.post(myUri, body: body).then((response) async {
      if (response.statusCode == 200) {
        var responsebody = response.body;
        print("responsebody=${response.body}");
        if (responsebody != "0") {
          idAnnonce = int.parse(responsebody);
          loadImages();
          Get.back(result: "success");
        } else {
          setValider(false);
          AppData.mySnackBar(
              title: 'Fiche Annonce',
              message: "Probleme lors de l'ajout !!!",
              color: AppColor.red);
        }
      } else {
        setValider(false);
        AppData.mySnackBar(
            title: 'Fiche Annonce',
            message: "Probleme de Connexion avec le serveur 13 !!!",
            color: AppColor.red);
      }
    }).catchError((error) {
      print("erreur : $error");
      setValider(false);
      AppData.mySnackBar(
          title: 'Fiche Annonce',
          message: "Probleme de Connexion avec le serveur 14 !!!",
          color: AppColor.red);
    });
  }

  updateAnnonce() async {
    String serverDir = AppData.getServerDirectory();
    String pGroupe = "", pParent = "", pEnfant = "";
    if (visibiliteMode == 2) {
      for (var i = 0; i < groupes.length; i++) {
        if (pGroupe.isNotEmpty) {
          pGroupe += ",";
        }
        pGroupe += groupes[i].id.toString();
      }
    } else if (visibiliteMode == 3) {
      for (var i = 0; i < parents.length; i++) {
        if (pParent.isNotEmpty) {
          pParent += ",";
        }
        pParent += parents[i].id.toString();
      }
    } else if (visibiliteMode == 4) {
      for (var i = 0; i < enfants.length; i++) {
        if (pEnfant.isNotEmpty) {
          pEnfant += ",";
        }
        pEnfant += enfants[i].id.toString();
      }
    }
    var body = {};
    body['ID_ANNONCE'] = idAnnonce.toString();
    body['TITRE'] = titreController.text;
    body['DETAILS'] = detailsController.text;
    body['TYPE'] = visibiliteMode.toString();
    body['GROUPES'] = pGroupe;
    body['PARENTS'] = pParent;
    body['ENFANTS'] = pEnfant;
    for (var i = 0; i < deletedImages.length; i++) {
      body['DEL_' + i.toString()] = deletedImages[i].toString();
    }
    body['NB_DELETED'] = deletedImages.length.toString();
    var url = "$serverDir/UPDATE_ANNONCE.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http.post(myUri, body: body).then((response) async {
      if (response.statusCode == 200) {
        var responsebody = response.toString();
        print("responsebody=${response.body}");
        if (responsebody != "0") {
          loadImages();
          Get.back(result: "success");
        } else {
          setValider(false);
          AppData.mySnackBar(
              title: 'Fiche Annonce',
              message: "Probleme lors de la mise à jours !!!",
              color: AppColor.red);
        }
      } else {
        setValider(false);
        AppData.mySnackBar(
            title: 'Fiche Annonce',
            message: "Probleme de Connexion avec le serveur 13 !!!",
            color: AppColor.red);
      }
    }).catchError((error) {
      print("erreur : $error");
      setValider(false);
      AppData.mySnackBar(
          title: 'Fiche Annonce',
          message: "Probleme de Connexion avec le serveur 13 !!!",
          color: AppColor.red);
    });
  }

  loadImages() {
    late ImageAnnounce e;
    for (var i = nbAnnImg; i < myImages.length; i++) {
      var item = myImages[i];
      e = ImageAnnounce(
          idAnnonce: idAnnonce,
          extension:
              p.extension(getFileName("IMAGE\\ANNONCE", File(item.chemin))),
          base64Image: base64Encode(File(item.chemin).readAsBytesSync()));
      GestAnnounceImages.myImages.add(e);
    }
  }

  addImage(MyAnnonceImage m) {
    myImages.add(m);
    print("image added");
    update();
  }

  removeImage(int index) {
    myImages.removeAt(index);
    print("image removed");
    update();
  }

  captureImage() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    addImage(MyAnnonceImage(chemin: image.path, num: 0));
  }

  pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images == null) return;
    for (var image in images) {
      addImage(MyAnnonceImage(chemin: image.path, num: 0));
    }
  }

  addGroupe(Groupe g) {
    groupes.add(g);
    print("groupe added");
    update();
  }

  removeGroupe(Groupe item) {
    groupes.removeAt(groupes.indexOf(item));
    print("groupe removed");
    update();
  }

  addParent(Parent p) {
    parents.add(p);
    print("parent added");
    update();
  }

  removeParent(Parent item) {
    parents.removeAt(parents.indexOf(item));
    print("parent removed");
    update();
  }

  addEnfant(Enfant e) {
    enfants.add(e);
    print("enfant added");
    update();
  }

  removeEnfant(Enfant item) {
    enfants.removeAt(enfants.indexOf(item));
    print("enfant removed");
    update();
  }

  showModal() async {
    await Get.bottomSheet(
        SelectCameraGalleryWidget(onTapCamera: () async {
          await captureImage();
          Get.back();
        }, onTapGallery: () async {
          await pickImages();
          Get.back();
        }),
        enterBottomSheetDuration: const Duration(milliseconds: 600),
        exitBottomSheetDuration: const Duration(milliseconds: 600));
  }

  onRadioChange(val) async {
    switch (val) {
      case "Public":
        visibiliteMode = 1;
        updateRadio(val);
        print("Every one ....");
        break;
      case "Groupe":
        visibiliteMode = 2;
        print("search for groupes");
        Get.to(() => const ListGroupeSelect());
        updateRadio(val);
        break;
      case "Parent":
        visibiliteMode = 3;
        print("search for parents");
        Get.to(() => const ListParentSelect());
        updateRadio(val);
        break;
      case "Enfant":
        visibiliteMode = 4;
        print("search for kids");
        Get.to(() => const ListEnfantSelect());
        //   await showDialog(context: context, builder: (_) => const SearchEnfant());
        updateRadio(val);
        break;
      default:
    }
  }

  String getFileName(String chemin, File updfile) {
    String ext = updfile.path.split('.').last;
    String bddFileName = idAnnonce.toString() + "." + ext;
    String fileName = chemin + "\\" + bddFileName;
    return fileName;
  }

  Future<bool> onWillPopVisibilite() async {
    return !((visibiliteMode == 2 && groupes.isEmpty) ||
        (visibiliteMode == 3 && parents.isEmpty) ||
        (visibiliteMode == 4 && enfants.isEmpty));
  }

  Future<bool> onWillPop() async {
    return (await showDialog(
            context: Get.context!,
            builder: (context) => AlertDialog(
                    title: Row(children: const [
                      Icon(Icons.cancel_outlined, color: Colors.red),
                      Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text('Annuler ?'))
                    ]),
                    content: const Text(
                        "Voulez-vous vraiment annuler tous les changements !!!"),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text('Non',
                              style: TextStyle(color: Colors.red))),
                      TextButton(
                          onPressed: () => Get.back(result: true),
                          child: const Text('Oui',
                              style: TextStyle(color: Colors.green)))
                    ]))) ??
        false;
  }

  updateLoading({newloading, newerror}) {
    loading = newloading;
    error = newerror;
    update();
  }

  updateLoadingSub({newloading}) {
    loadingSub = newloading;
    update();
  }

  getMyGroupes(List s) async {
    updateLoadingSub(newloading: true);
    String serverDir = AppData.getServerDirectory();
    String pWhere = "";
    for (var item in s) {
      if (pWhere != "") {
        pWhere += " OR ";
      }
      pWhere += " E.ID_GROUPE = " + item;
    }
    pWhere = " AND (" + pWhere + " )";
    var url = "$serverDir/GET_GROUPES.php";
    print("url=$url");
    groupes.clear();
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"WHERE": pWhere})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Groupe e;
            for (var m in responsebody) {
              e = Groupe(
                  designation: m['DESIGNATION'],
                  etat: int.parse(m['ETAT']),
                  id: int.parse(m['ID_GROUPE']));
              groupes.add(e);
            }
            updateLoadingSub(newloading: false);
          } else {
            groupes.clear();
            updateLoadingSub(newloading: false);
            AppData.mySnackBar(
                title: 'Fiche Annonce',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          groupes.clear();
          updateLoadingSub(newloading: false);
          AppData.mySnackBar(
              title: 'Fiche Annonce',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  getMyParents(List s) async {
    updateLoadingSub(newloading: true);
    String serverDir = AppData.getServerDirectory();
    String pWhere = "";
    for (var item in s) {
      if (pWhere != "") {
        pWhere += " OR ";
      }
      pWhere += " E.ID_PARENT = " + item;
    }
    pWhere = " AND (" + pWhere + " )";
    var url = "$serverDir/GET_PARENTS.php";
    print("url=$url");
    parents.clear();
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"WHERE": pWhere})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Parent p;
            late int sexe;
            for (var m in responsebody) {
              sexe = int.parse(m['SEXE']);
              p = Parent(
                  nom: m['NOM'],
                  prenom: m['PRENOM'],
                  fullName: m['NOM'] + "  " + m['PRENOM'],
                  dateNaiss: m['DATE_NAISS'],
                  id: int.parse(m['ID_PARENT']),
                  idUser: int.parse(m['ID_USER']),
                  etat: int.parse(m['ETAT']),
                  userName: m['USERNAME'],
                  password: m['PASSWORD'],
                  sexe: sexe,
                  adresse: m['ADRESSE'],
                  tel2: m['TEL2'],
                  isHomme: (sexe == 1),
                  isFemme: (sexe == 2),
                  tel1: m['TEL1']);
              parents.add(p);
            }
            updateLoadingSub(newloading: false);
          } else {
            parents.clear();
            updateLoadingSub(newloading: false);
            AppData.mySnackBar(
                title: 'Fiche Annonce',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          parents.clear();
          updateLoadingSub(newloading: false);
          AppData.mySnackBar(
              title: 'Fiche Annonce',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  getMyEnfants(List s) async {
    updateLoadingSub(newloading: true);
    String serverDir = AppData.getServerDirectory();
    String pWhere = "";
    for (var item in s) {
      if (pWhere != "") {
        pWhere += " OR ";
      }
      pWhere += " E.ID_ENFANT = " + item;
    }
    pWhere = " AND (" + pWhere + " )";
    var url = "$serverDir/GET_ENFANTS.php";
    print("url=$url");
    enfants.clear();
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"WHERE": pWhere})
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
                  isHomme: (sexe == 1),
                  isFemme: (sexe == 2),
                  photo: m['PHOTO']);
              enfants.add(e);
            }
            updateLoadingSub(newloading: false);
          } else {
            enfants.clear();
            updateLoadingSub(newloading: false);
            AppData.mySnackBar(
                title: 'Fiche Annonce',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          enfants.clear();
          updateLoadingSub(newloading: false);
          AppData.mySnackBar(
              title: 'Fiche Annonce',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  getAnnonceInfo() async {
    updateLoading(newloading: true, newerror: false);
    myImages = [];
    nbAnnImg = 0;
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_INFO_ANNONCE.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_ANNONCE": idAnnonce.toString()})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            String s = "", ns = "";
            List ls = [], nls = [];
            MyAnnonceImage e;
            for (var m in responsebody) {
              titreController.text = m['TITRE'];
              detailsController.text = m['DETAILS'];
              visibiliteMode = int.parse(m['VISIBILITE']);

              // partie groupes
              s = m['GROUPES'];
              if (s.isNotEmpty) {
                ls = s.split(",");
                await getMyGroupes(ls);
              }

              // partie PARENT
              s = m['PARENTS'];
              if (s.isNotEmpty) {
                ls = s.split(",");
                await getMyParents(ls);
              }

              // partie ENFANT
              s = m['ENFANTS'];
              if (s.isNotEmpty) {
                ls = s.split(",");
                await getMyEnfants(ls);
              }

              // partie images
              ns = m['NUMS'];
              s = m['IMAGES'];
              s.isEmpty ? ls = [] : ls = s.split(",");
              ns.isEmpty ? nls = [] : nls = ns.split(",");
              for (var i = 0; i < ls.length; i++) {
                e = MyAnnonceImage(chemin: ls[i], num: int.parse(nls[i]));
                myImages.add(e);
              }
              nbAnnImg = myImages.length;

              switch (visibiliteMode) {
                case 1:
                  radio = "Public";
                  break;
                case 2:
                  radio = "Groupe";
                  break;
                case 3:
                  radio = "Parent";
                  break;
                case 4:
                  radio = "Enfant";
                  break;
                default:
              }
            }
            updateLoading(newloading: false, newerror: false);
          } else {
            updateLoading(newloading: false, newerror: true);
            AppData.mySnackBar(
                title: 'Fiche Annonce',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          updateLoading(newloading: false, newerror: true);
          AppData.mySnackBar(
              title: 'Fiche Annonce',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    print('idAnnonce=$idAnnonce');
    titreController = TextEditingController();
    detailsController = TextEditingController();
    if (idAnnonce != 0) getAnnonceInfo();
    super.onInit();
  }

  @override
  void onClose() {
    titreController.dispose();
    detailsController.dispose();
    super.onClose();
  }
}
