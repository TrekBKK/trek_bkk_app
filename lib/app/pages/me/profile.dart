import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:trek_bkk_app/app/pages/me/settings.dart';
import 'package:trek_bkk_app/app/widgets/me_menu.dart';
import 'package:trek_bkk_app/app/widgets/snackbar.dart';
import 'package:trek_bkk_app/constants.dart';
import 'package:trek_bkk_app/domain/entities/user.dart';
import 'package:trek_bkk_app/domain/repositories/firebase_api.dart';
import 'package:trek_bkk_app/providers/user.dart';

class ProfilePage extends StatefulWidget {
  final UserModel? user;
  const ProfilePage({super.key, this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  XFile? _imagePath;
  File? _image;
  bool isLoading = false;
  final FirebaseStorageService storageService = FirebaseStorageService();

  Future<void> confirmImageChange(BuildContext ctx) async {
    if (context.mounted) {
      setState(() {
        isLoading = true;
      });
      final scaffoldMessenger = ScaffoldMessenger.of(ctx);
      final userData = Provider.of<UserData>(ctx, listen: false);

      String imagePath = '';
      if (_imagePath != null) {
        imagePath = await storageService.uploadFile(_imagePath!);
      }
      await userData.updateUserImage(
          userData.user!.name, userData.user!.email, imagePath);
      scaffoldMessenger.showSnackBar(successSnackbar("Success!"));
      setState(() {
        _imagePath = null;
        _image = null;
        isLoading = false;
      });
    }
  }

  void cancelImageChange() {
    setState(() {
      _imagePath = null;
      _image = null;
    });
  }

  Future<void> pickImage(String method) async {
    try {
      XFile? image;
      if (method == 'camera') {
        image = await ImagePicker().pickImage(source: ImageSource.camera);
      } else if (method == 'gallery') {
        image = await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        return;
      }

      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() {
        _image = imageTemp;
        _imagePath = image;
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to get image: $e');
    }
  }

  Future<void> _showDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    pickImage('camera');
                    Navigator.of(context).pop();
                  },
                  splashColor: Colors.blue.withOpacity(0.5),
                  child: Row(
                    children: const [
                      Icon(Icons.camera_alt, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(
                        'Take a picture',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    pickImage('gallery');
                    Navigator.of(context).pop();
                  },
                  splashColor: Colors.blue.withOpacity(0.5),
                  child: Row(
                    children: const [
                      Icon(Icons.image, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(
                        'select from gallery',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserData userProvider = Provider.of<UserData>(context, listen: false);
    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                Widget>[
          Container(
              decoration: const BoxDecoration(color: lightColor),
              child: Align(
                  alignment: const Alignment(1, 0),
                  child: buildSettings(context))),
          Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                            radius: 60,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : userProvider.user!.photoUrl != ''
                                    ? NetworkImage(userProvider.user!.photoUrl!)
                                    : const AssetImage(
                                            "assets/images/ImagePlaceHolder.jpg")
                                        as ImageProvider),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: _image == null
                              ? InkWell(
                                  onTap: () {
                                    _showDialog(context);
                                  },
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.black,
                                    size: 24.0,
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    confirmImageChange(context);
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 24.0,
                                    ),
                                  ),
                                ),
                        ),
                        if (_image != null)
                          Positioned(
                              bottom: 0,
                              left: 0,
                              child: InkWell(
                                onTap: () {
                                  cancelImageChange();
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                ),
                              )),
                        if (isLoading)
                          const Positioned.fill(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator()))
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userProvider.user!.name),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border:
                                    Border.all(width: 1, color: Colors.black)),
                            child: LinearPercentIndicator(
                              width: 120.0,
                              lineHeight: 15.0,
                              percent: userProvider.user!.routesHistory.length
                                      .clamp(0, 10) /
                                  10,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              barRadius: const Radius.circular(16),
                              progressColor: Colors.blue[400],
                              backgroundColor: Colors.grey[300],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                              '${userProvider.user!.routesHistory.length} routes visited'),
                        ],
                      ),
                    )
                  ],
                ),
              )),
          Flexible(
              flex: 7, fit: FlexFit.tight, child: MeMenu(user: widget.user)),
        ]),
      )),
    );
  }
}

Widget buildSettings(BuildContext context) => IconButton(
    onPressed: (() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Settings()));
    }),
    icon: const Icon(Icons.settings));
