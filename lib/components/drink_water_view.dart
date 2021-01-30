import 'package:flutter/material.dart';

class DrinkWaterView extends StatefulWidget {
  DrinkWaterView({Key key}) : super(key: key);

  @override
  _DrinkWaterViewState createState() => _DrinkWaterViewState();
}

class _DrinkWaterViewState extends State<DrinkWaterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red,
              width: 2,
            ),
          ),
          child: GestureDetector(
            onTap: () {
              print('Bottle tapped');
            },
            onDoubleTap: () {},
            onLongPress: () {},
            child: Image.asset(
              'assets/images/bottle.png',
              width: 200,
              height: 400,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
