import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:emergency/models/user.dart';
import 'package:emergency/services/userCRUD.dart';
import 'package:emergency/srceens/Widget/customContainer.dart';
import 'package:emergency/srceens/welcomePage.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfilePage extends StatefulWidget {
  String fullName;
  String dateOfBirth;
  String gender;
  String address;
  String phoneNumber;
  String email;
  String passport;
  String idCard;
  String healthIssues;
  User user = User();

  UserProfilePage({this.user});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        auth.FirebaseAuth.instance.signOut();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WelcomePage()));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  User _user = new User();

  TextEditingController _fullNameController;
  TextEditingController _dateOfBirthController;
  TextEditingController _genderController;
  TextEditingController _addressController;
  TextEditingController _phoneNumberController;
  TextEditingController _emailController;
  TextEditingController _passportController;
  TextEditingController _idCardController;
  TextEditingController _healthIssuesController;

  @override
  void initState() {
    // TODO: implement initState
    _user = widget.user;

    _fullNameController = new TextEditingController(text: _user.fullName);
    _dateOfBirthController = new TextEditingController(text: _user.dateOfBirth);
    _addressController = new TextEditingController(text: _user.address);
    _genderController = new TextEditingController(text: _user.gender);
    _phoneNumberController = new TextEditingController(text: _user.phoneNumber);
    _emailController = new TextEditingController(text: _user.email);
    _passportController = new TextEditingController(text: _user.passport);
    _idCardController = new TextEditingController(text: _user.idCard);
    _healthIssuesController =
        new TextEditingController(text: _user.healthIssues);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: CustomContainer(),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 160,
                            height: 160,
                            child: CircleAvatar(
                              backgroundImage:
                                  _user.photo.startsWith("https", 0)
                                      ? NetworkImage(_user.photo)
                                      : AssetImage("assets/img1.jpg"),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Full Name',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _fullNameController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                  onSaved: (val) {
                                    _user.fullName = val;
                                  },
                                  validator: (val) {
                                    if (val.trim().isEmpty) {
                                      return 'Full name can not be empty !';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Date of birth',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _dateOfBirthController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                  onSaved: (val) {
                                    _user.dateOfBirth = val;
                                  },
                                  validator: (val) {
                                    if (val.trim().isEmpty) {
                                      return 'Date of birth can not be empty !';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Gender',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _genderController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                  onSaved: (val) {
                                    _user.gender = val;
                                  },
                                  validator: (val) {
                                    if (val.trim().isEmpty) {
                                      return 'Gender can not be empty !';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Address',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _addressController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                  onSaved: (val) {
                                    _user.address = val;
                                  },
                                  validator: (val) {
                                    if (val.trim().isEmpty) {
                                      return 'Address can not be empty !';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Phone number',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _phoneNumberController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                  onSaved: (val) {
                                    _user.phoneNumber = val;
                                  },
                                  validator: (val) {
                                    if (val.trim().isEmpty) {
                                      return 'Phone number can not be empty !';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Email',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _emailController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                  onSaved: (val) {
                                    _user.email = val;
                                  },
                                  validator: (val) {
                                    if (val.trim().isEmpty) {
                                      return 'Email can not be empty !';
                                    }
                                    if (!val.trim().contains('@')) {
                                      return 'Enter a correct email !';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Upload Passport',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _passportController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                  onSaved: (val) {
                                    _user.passport = val;
                                  },
                                  /*validator: (val){
                                      if(val.trim().isEmpty){
                                        return 'this can not be empty !';
                                      }
                                      return null;
                                    },*/
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Upload Id Card',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _idCardController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                  onSaved: (val) {
                                    _user.idCard = val;
                                  },
                                  /*validator: (val){
                                      if(val.trim().isEmpty){
                                        return 'This can not be empty !';
                                      }
                                      return null;
                                    },*/
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Previous health issues',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _healthIssuesController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                  onSaved: (val) {
                                    _user.healthIssues = val;
                                  },
                                  /*validator: (val){
                                      if(val.trim().isEmpty){
                                        return 'this can not be empty !';
                                      }
                                      return null;
                                    },*/
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          if (_isBusy) CircularProgressIndicator(),
                          if (!_isBusy)
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.grey.shade200,
                                        offset: Offset(2, 4),
                                        blurRadius: 5,
                                        spreadRadius: 2)
                                  ],
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xfffbb448),
                                        Color(0xfff7892b)
                                      ])),
                              child: InkWell(
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                onTap: _submitForm,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var _isBusy = false;

  void _submitForm() async {
    final isValid = _formKey.currentState.validate();

    UserCRUD userCRUD = new UserCRUD();

    if (isValid) {
      _formKey.currentState.save();
      FocusScope.of(context).unfocus();
      setState(() {
        _isBusy = true;
      });

      try {
        userCRUD.updateData(_user.id, _user.toJson());

        _scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text('Information saves succefully ....')));
      } on PlatformException catch (e) {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(e.message)));
      } catch (ex) {
        print(ex);
      } finally {
        if (this.mounted) {
          setState(() {
            _isBusy = false;
          });
        }
      }
    }
  }
}
