import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/models/drink_water_menu_item.dart';
import 'package:water_reminder/providers/drink_water_provider.dart';

class DrinkWaterView extends StatefulWidget {
  DrinkWaterView({Key key}) : super(key: key);

  @override
  _DrinkWaterViewState createState() => _DrinkWaterViewState();
}

class _DrinkWaterViewState extends State<DrinkWaterView> {
  final List<DrinkWaterMenuItem> _drinkWaterMenuItems = [
    DrinkWaterMenuItem(
      title: 'Add custom amount',
      choice: DrinkWaterMenuChoice.add,
    ),
    DrinkWaterMenuItem(
      title: 'Undo last drink',
      choice: DrinkWaterMenuChoice.undo,
    ),
    DrinkWaterMenuItem(
      title: 'Reset current day',
      choice: DrinkWaterMenuChoice.reset,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var _tapPosition;

    // popup menu for long press bottle
    void _showDrinkWaterMenu() {
      final RenderBox overlay = Overlay.of(context).context.findRenderObject();

      showMenu(
        context: context,
        position: RelativeRect.fromRect(
          _tapPosition & const Size(-50, 100),
          Offset.zero & overlay.size,
        ),
        items: _drinkWaterMenuItems.map(
          (item) {
            return PopupMenuItem<DrinkWaterMenuItem>(
              value: item,
              child: Text(item.title),
            );
          },
        ).toList(),
      ).then(
        (selectedItem) {
          if (selectedItem == null) return;
          switch (selectedItem.choice) {
            case DrinkWaterMenuChoice.add:
              break;
            case DrinkWaterMenuChoice.undo:
              break;
            case DrinkWaterMenuChoice.reset:
              break;
            default:
          }
        },
      );
    }

    // save gesture detector tap position
    void _storeTapPosition(TapDownDetails details) {
      _tapPosition = details.globalPosition;
    }

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
                    value: viewModel.drinkWaterProgress,
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
                onTapDown: _storeTapPosition,
                onTap: () {
                  viewModel.addOneDrink();
                },
                onDoubleTap: () {
                  viewModel.addDoubleDrink();
                },
                onLongPress: _showDrinkWaterMenu,
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
