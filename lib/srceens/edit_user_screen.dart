import 'package:emergency/models/user_model.dart';
import 'package:emergency/srceens/login_screen.dart';
import 'package:emergency/srceens/patient_screen.dart';
import 'package:flutter/material.dart';
import 'package:emergency/srceens/choose_location.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:emergency/constants.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency/constants.dart';
import 'package:emergency/components/rounded_button.dart';
import 'package:emergency/models/emergency_model.dart';
import 'package:email_validator/email_validator.dart';
import 'login_screen.dart';
import 'package:emergency/models/user_model.dart';
import 'responder_screen.dart';

final _firestore = FirebaseFirestore.instance.collection('Users_infos');

class EditUserprofile extends StatefulWidget {
  final Map users;
  EditUserprofile({this.users});

  @override
  _EditUserprofileState createState() => _EditUserprofileState();
}

class _EditUserprofileState extends State<EditUserprofile> {
  bool verif;
  final _auth = auth.FirebaseAuth.instance;
  String profileName = "";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SnackBar _snackbar;
  final _formKey = GlobalKey<FormState>();
  String dropdownValue;
  String confirmPassword;
  String password;
  //Images upload
  File _image;
  String _uploadedFileURL = "";

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
          .child('profiles/${Path.basename(_image.path)}}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text('Welcome  ${widget.users['firstName']}'),
        backgroundColor: Color(0xffe46b10),
        centerTitle: true,
      ),
      drawer: SafeArea(
        child: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
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
                        profileName.toUpperCase(),
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
                        'Home',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      trailing: Icon(Icons.home),
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
                        'Logout',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      trailing: Icon(Icons.logout),
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
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      'Edit your profile',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    FutureBuilder(
                        future: User().getUserData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final List<Widget> monForm = [];
                            var map = snapshot.data[0];
                            String docId = snapshot.data[1];

                            print(docId);

                            var form = Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                        initialValue: map['firstName'],
                                        style: TextStyle(
                                          color: Colors.black54,
                                        ),
                                        keyboardType: TextInputType.text,
                                        textAlign: TextAlign.center,
                                        onChanged: (value) {
                                          setState(() {
                                            map['firstName'] = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Cannot be empty';
                                          }
                                          return null;
                                        },
                                        decoration:
                                            kTextFieldDecoration.copyWith(
                                          hintText: 'First Name',
                                          prefixText: 'First Name :',
                                        )),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    TextFormField(
                                      initialValue: map['lastName'],
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                      keyboardType: TextInputType.text,
                                      textAlign: TextAlign.center,
                                      onChanged: (value) {
                                        setState(() {
                                          map['lastName'] = value;
                                        });
                                      },
                                      decoration: kTextFieldDecoration.copyWith(
                                        hintText: 'Last Name',
                                        prefixText: 'Last Name :',
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Cannot be empty';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    TextFormField(
                                      initialValue: map['phone'],
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                      keyboardType: TextInputType.phone,
                                      textAlign: TextAlign.center,
                                      onChanged: (value) {
                                        setState(() {
                                          map['phone'] = value;
                                        });
                                      },
                                      decoration: kTextFieldDecoration.copyWith(
                                        hintText: 'Phone number',
                                        prefixText: 'Phone :',
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Cannot be empty';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    TextFormField(
                                      initialValue: map['email'],
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      textAlign: TextAlign.center,
                                      onChanged: (value) {
                                        setState(() {
                                          map['email'] = value;
                                        });
                                      },
                                      decoration: kTextFieldDecoration.copyWith(
                                        hintText: 'Email',
                                        prefixText: 'Email : ',
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Cannot be empty';
                                        } else if (!EmailValidator.validate(
                                            value)) {
                                          return 'wrong email';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    TextFormField(
                                      initialValue: map['password'],
                                      obscureText: true,
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                      keyboardType: TextInputType.text,
                                      textAlign: TextAlign.center,
                                      onChanged: (value) {
                                        setState(() {
                                          password = value;
                                        });
                                      },
                                      decoration: kTextFieldDecoration.copyWith(
                                        hintText: 'Password',
                                        prefixText: 'Password : ',
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Cannot be empty';
                                        }
                                        if (password != confirmPassword) {
                                          return 'password must be at least 6 caracter';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    TextFormField(
                                      initialValue: map['password'],
                                      obscureText: true,
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                      keyboardType: TextInputType.text,
                                      textAlign: TextAlign.center,
                                      onChanged: (value) {
                                        confirmPassword = value;
                                      },
                                      decoration: kTextFieldDecoration.copyWith(
                                        hintText: ' Confirm password',
                                        prefixText: 'Confirm password :',
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Cannot be empty';
                                        }
                                        if (password != confirmPassword) {
                                          return 'passwords do not match';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    RoundedButton(
                                        color: Color(0xffe46b10),
                                        title: 'Update',
                                        onPressed: () async {
                                          //Form Validation
                                          if (_formKey.currentState
                                              .validate()) {
                                            if (password != null)
                                              map['password'] = password;
                                            // showSpinner = true;
                                            showSnack();

                                            var upload = await uploadFile();

                                            if (upload is String) {
                                              showSnack(
                                                  color: kColorFailed,
                                                  message: upload);
                                            } else {
                                              map['photo'] = _uploadedFileURL;
                                              User user = User();
                                              var loc =
                                                  await user.getLocation();

                                              if (loc is String) {
                                                showSnack(
                                                    color: Color(0xffb85132),
                                                    message: loc);
                                              } else {
                                                map['latitude'] = loc['lat'];
                                                map['longitude'] = loc['lat'];
                                                var fin = await user.updateUser(
                                                    map, docId);

                                                if (fin is String) {
                                                  showSnack(
                                                      color: kColorFailed,
                                                      message: fin);

                                                  if (fin == 'login') {
                                                    Navigator.pushNamed(
                                                        context, Login.id);
                                                  }
                                                } else {
                                                  showSnack(
                                                      color: kColorLoading,
                                                      message:
                                                          "Your informations has been updated");

                                                  map['statut'] == 'Responder'
                                                      ? Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                          return Responder(
                                                            users: map,
                                                            send: false,
                                                          );
                                                        }))
                                                      : Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                          return Patient(
                                                              users: map,
                                                              send: false);
                                                        }));
                                                }
                                              }
                                            }
                                          }
                                        }),
                                  ],
                                ));

                            _uploadedFileURL = map['photo'];

                            var photo = map['photo'] == ""
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(65.0),
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: 35.0,
                                    ))
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(65.0),
                                    child: Image.network(map['photo']),
                                  );

                            return Column(children: [
                              GestureDetector(
                                child: _image == null
                                    ? photo
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(65.0),
                                        child: Image.file(_image, height: 120),
                                      ),
                                onTap: () {
                                  chooseFile();
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              form
                            ]);
                          }

                          return Text('');
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.users['statut'] == 'Patient')
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Location(users: widget.users);
            }));
        },
        child: Image.asset('images/alert_96px.png'),
        backgroundColor: Color(0xffe46b10),
      ),
    );
  }
}
