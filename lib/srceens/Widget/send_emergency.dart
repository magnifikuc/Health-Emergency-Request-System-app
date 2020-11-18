import 'package:emergency/srceens/patient_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:emergency/constants.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency/constants.dart';
import 'package:emergency/models/emergency_model.dart';

Map damage_type = {
  'fever': 1,
  'headaches': 2,
  'diabetes': 3,
  'asthma': 4,
  'epilepsy': 5,
};

class SendEmergency extends StatefulWidget {
  Map users;
  PickResult result;

  SendEmergency({this.users, this.result});

  @override
  _SendEmergencyState createState() => _SendEmergencyState();
}

class _SendEmergencyState extends State<SendEmergency> {
  final _auth = auth.FirebaseAuth.instance;
  String _profileName = "";
  String _message = "";
  String _damage = "fever";
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();

  SnackBar _snackbar;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _picker = ImagePicker();
  String dropdownValue;
  final _authFirestore = FirebaseFirestore.instance;

  //Images upload
  File _image;
  String _uploadedFileURL;

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Choosen Location: ',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xff1c1318),
          ),
          children: [
            TextSpan(
              text: '${widget.result.formattedAddress}',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 20),
            ),
          ]),
    );
  }

  //Take a picture
  Future takePicture() async {
    try {
      final pickedFile = await _picker.getImage(source: ImageSource.camera);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        }
      });

      return true;
    } catch (e) {
      return e.message;
    }
  }

  //Select image from disk
  Future chooseFile() async {
    try {
      await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
        setState(() {
          _image = image;
        });

        return true;
      });
    } catch (e) {
      return e.message;
    }
  }

  //Upload the image
  Future uploadFile() async {
    try {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('emergencies/${Path.basename(_image.path)}}');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          _uploadedFileURL = fileURL;
        });
      });
      return true;
    } catch (e) {
      return e.message;
    }
  }

  void showSnack(
      {Color color = kColorLoading, String message = "Sending in progress"}) {
    _scaffoldKey.currentState.removeCurrentSnackBar();

    _snackbar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: color,
    );
    _scaffoldKey.currentState.showSnackBar(_snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.logout,
                  semanticLabel: 'logout',
                ),
                onPressed: () {
                  _auth.signOut();
                  Navigator.pop(context);
                  // messagesStream();
                }),
          ],
          title: Text('Emergency description'),
          backgroundColor: Color(0xffe46b10),
          centerTitle: true,
        ),
        drawer: SafeArea(
          child: Drawer(
            child: ListView(
              children: <Widget>[
                Container(
                  color: Color(0xffe46b10),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CircleAvatar(
                          child: Image.asset('images/nurse_male_480px.png'),
                          backgroundColor: Color(0xffe46b10),
                          radius: 40.0,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          _profileName.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            wordSpacing: 10.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Card(
                      child: ListTile(
                        title: Text(
                          'Requests List',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        trailing: Icon(Icons.local_hospital),
                        onTap: () {},
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text(
                          'Requests List',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        trailing: Icon(Icons.help_center),
                        onTap: () {},
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text(
                          'Edit profile',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        trailing: Icon(Icons.settings),
                        onTap: () {},
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text(
                          'About',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        trailing: Icon(Icons.help),
                        onTap: () {},
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        trailing: Icon(Icons.logout),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Hero(
                          tag: 'trans',
                          child: _title(),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DropdownButtonFormField(
                                  hint: Text(
                                    'Type of emergency',
                                    textAlign: TextAlign.center,
                                  ),
                                  value: _damage,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15.0,
                                  ),
                                  validator: (value) {
                                    if (_damage == null) {
                                      return 'You must select a type';
                                    }
                                    return null;
                                  },
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _damage = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'fever',
                                    'headaches',
                                    'diabetes',
                                    'asthma',
                                    'epilepsy',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  textAlign: TextAlign.center,
                                  onChanged: (value) {
                                    _message = value;
                                  },
                                  decoration: kTextFieldDecoration.copyWith(
                                    hintText: 'Write a description',
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Description cannot be empty';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                DropdownButtonFormField(
                                  hint: Text('Choose an image'),
                                  value: dropdownValue,
                                  icon: Icon(Icons.image),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15.0,
                                  ),
                                  validator: (value) {
                                    if (_image == null) {
                                      return 'You must select an image';
                                    }
                                    return null;
                                  },
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                      if (newValue ==
                                          'Take a picture from camera') {
                                        // call camera
                                        takePicture();
                                      } else if (newValue ==
                                          'upload an image from your disk') {
                                        // call disk
                                        chooseFile();
                                      }
                                    });
                                  },
                                  items: <String>[
                                    'Take a picture from camera',
                                    'upload an image from your disk',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(
                                  height: 25.0,
                                ),
                                _image == null
                                    ? Text('No image')
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(65.0),
                                        child: Image.file(_image, height: 300),
                                      ),
                                SizedBox(
                                  height: 25.0,
                                ),
                                Ink(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: const ShapeDecoration(
                                    color: Color(0xffe46b10),
                                    shape: CircleBorder(),
                                  ),
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.send,
                                        size: 35.0,
                                      ),
                                      color: Colors.white,
                                      onPressed: () async {
                                        //Form Validation
                                        if (_formKey.currentState.validate()) {
                                          showSpinner = true;
                                          //Sending process

                                          // 1- uploading image
                                          showSnack();
                                          var upload = await uploadFile();
                                          if (upload is String) {
                                            showSnack();
                                          } else {
                                            Map<String, dynamic> emergency = {
                                              'date_sending': DateTime.now(),
                                              'date_response': DateTime.now(),
                                              'address': widget
                                                  .result.formattedAddress,
                                              'damage': _damage,
                                              'damage_value':
                                                  damage_type[_damage],
                                              'description': _message,
                                              'lat': widget
                                                  .result.geometry.location.lat,
                                              'lng': widget
                                                  .result.geometry.location.lng,
                                              'patiendID': widget.users['uid'],
                                              'photoUrl': _uploadedFileURL,
                                              'user_name':
                                                  widget.users['lastName'],
                                              'responder_name': '',
                                              'responded': false,
                                            };

                                            Emergency emergence = Emergency();

                                            emergence.initializeData(emergency);

                                            var sending =
                                                await emergence.addDatas();

                                            if (sending is String) {
                                              showSnack(
                                                  color: kColorFailed,
                                                  message: sending);
                                            } else {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return Patient(
                                                    users: widget.users,
                                                    send: true);
                                              }));
                                            }
                                          }

                                          showSpinner = false;
                                        }
                                      }),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
