import 'package:flutter/material.dart';

class DrinkWaterView extends StatefulWidget {
  DrinkWaterView({Key key}) : super(key: key);

  @override
  _DrinkWaterViewState createState() => _DrinkWaterViewState();
}

class _DrinkWaterViewState extends State<DrinkWaterView> {
  double _progress = 0.75;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 30,
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColorLight),
              ),
            ),
            Text(
              '500 / 2000 ml',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
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
