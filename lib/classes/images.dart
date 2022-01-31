import 'dart:io';

class MyImage {
  final int type;
  int num;
  final String chemin;
  final File? file;
  MyImage(
      {required this.type,
      required this.file,
      required this.num,
      required this.chemin});
}
