import 'package:flutter/cupertino.dart';

class UserRemoveAccountPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Center(
        child: Text(
          'CLICK HERE TO REMOVE YOUR ACCOUNT',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}