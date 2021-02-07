import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/providers/drink_water_provider.dart';

class DrinkWaterView extends StatefulWidget {
  DrinkWaterView({Key key}) : super(key: key);

  @override
  _DrinkWaterViewState createState() => _DrinkWaterViewState();
}

class _DrinkWaterViewState extends State<DrinkWaterView> {
  double _getProgressValue(int currentValue, int requiredValue) {
    if (currentValue == 0 || requiredValue == 0) return 0.0;
    if (currentValue >= requiredValue) return 1.0;
    return (currentValue / requiredValue);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrinkWaterProvider>(
      builder: (context, viewModel, child) {
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
                    value: _getProgressValue(
                      viewModel.drinkWaterAmountCurrent,
                      viewModel.drinkWaterAmountRequired,
                    ),
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColorLight),
                  ),
                ),
                Text(
                  '${viewModel.drinkWaterAmountCurrent} / ${viewModel.drinkWaterAmountRequired} ml',
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
                  viewModel.addOneDrink();
                },
                onDoubleTap: () {
                  viewModel.addDoubleDrink();
                },
                onLongPress: () {
                  // show input custom value dialog ->
                  // viewModel.addCustomDrink(addedWaterAmount);
                },
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
      },
    );
  }
}
