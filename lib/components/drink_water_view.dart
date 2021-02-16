import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/models/drink_water_menu_item.dart';
import 'package:water_reminder/providers/drink_water_provider.dart';

class DrinkWaterView extends StatefulWidget {
  DrinkWaterView({Key key}) : super(key: key);

  @override
  _DrinkWaterViewState createState() => _DrinkWaterViewState();
}

class _DrinkWaterViewState extends State<DrinkWaterView> {
  // gesture detector tap position
  var _tapPosition;

  // popup menu items list
  final List<DrinkWaterMenuItem> _drinkWaterMenuItems = [
    DrinkWaterMenuItem(
      title: 'Add custom amount',
      choice: DrinkWaterMenuChoice.add,
    ),
    DrinkWaterMenuItem(
      title: 'Undo previous drink',
      choice: DrinkWaterMenuChoice.undo,
    ),
    DrinkWaterMenuItem(
      title: 'Reset current progress',
      choice: DrinkWaterMenuChoice.reset,
    ),
  ];

  // dialogs
  GlobalKey<FormState> _addCustomWaterAmountDialogFormKey =
      GlobalKey<FormState>();
  TextEditingController _customWaterAmountController = TextEditingController();

  // add custom water amount
  void _addCustomWaterAmount() {
    if (!_addCustomWaterAmountDialogFormKey.currentState.validate()) return;
    _addCustomWaterAmountDialogFormKey.currentState.save();
    // parse form values
    final customWaterAmount = int.parse(_customWaterAmountController.text);
    // add
    Provider.of<DrinkWaterProvider>(
      context,
      listen: false,
    ).addCustomDrink(customWaterAmount);
    // reset form
    _addCustomWaterAmountDialogFormKey.currentState.reset();
    // close dialog
    Navigator.of(context).pop();
  }

  // reset current day progress
  void _resetCurrentDayProgress() {
    Provider.of<DrinkWaterProvider>(
      context,
      listen: false,
    ).resetCurrentProgress();

    Navigator.of(context).pop();
  }

  // save gesture detector tap position
  void _storeTapPosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  // check drink actions history to avoid undo
  bool _checkIsUndoPossible() {
    return Provider.of<DrinkWaterProvider>(
      context,
      listen: false,
    ).isPossibleUndoDrinkAction;
  }

  // popup menu items actions
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Form(
            key: _addCustomWaterAmountDialogFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _customWaterAmountController,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Input water amount (ml)';
                    if (int.parse(value) <= 0)
                      return 'Incorrect water amount value';
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Input water amount (ml)',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Add'),
              onPressed: _addCustomWaterAmount,
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _undoPreviousDrinkAction() {
    Provider.of<DrinkWaterProvider>(
      context,
      listen: false,
    ).undoLastDrink();
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text('Reset current day progress?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Reset'),
              onPressed: _resetCurrentDayProgress,
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

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
            enabled: item.choice == DrinkWaterMenuChoice.undo
                ? _checkIsUndoPossible()
                : true,
          );
        },
      ).toList(),
    ).then(
      (selectedItem) {
        if (selectedItem == null) return;
        switch (selectedItem.choice) {
          case DrinkWaterMenuChoice.add:
            _showAddDialog();
            break;
          case DrinkWaterMenuChoice.undo:
            _undoPreviousDrinkAction();
            break;
          case DrinkWaterMenuChoice.reset:
            _showResetDialog();
            break;
          default:
        }
      },
    );
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
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     color: Colors.red,
              //     width: 2,
              //   ),
              // ),
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
