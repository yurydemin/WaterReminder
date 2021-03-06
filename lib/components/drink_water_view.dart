import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/helpers/notifications_helper.dart';
import 'package:water_reminder/models/drink_water_menu_item.dart';
import 'package:water_reminder/providers/drink_water_provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

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
    // check congratulations
    _checkCongratulations();
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

  // congratulations dialog
  void _checkCongratulations() {
    if (Provider.of<DrinkWaterProvider>(
      context,
      listen: false,
    ).showProgressCongratulations) _showCongratulationsDialog();
  }

  void _setCongratulationsDone() {
    Provider.of<DrinkWaterProvider>(
      context,
      listen: false,
    ).setCongratulationsDone();
    Navigator.of(context).pop();
  }

  void _showCongratulationsDialog() {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text('Today\'s goal has been achived!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Good job'),
              onPressed: _setCongratulationsDone,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    AwesomeNotifications().actionStream.listen((recievedAction) {
      // clicked on buttons
      if (!StringUtils.isNullOrEmpty(recievedAction.buttonKeyPressed)) {
        switch (recievedAction.buttonKeyPressed) {
          // handle drink button click
          case 'DRINK':
            print('button drink clicked');
            Provider.of<DrinkWaterProvider>(
              context,
              listen: false,
            ).addOneDrink();
            break;
          // handle reschedule button click
          case 'RESCHEDULE':
            // ToDo reschedule notification
            break;
          default:
            print('default');
        }
      }
      // clicked on notification
      else {
        NotificationsHelper.cancelAllScheduleNotifications();
      }
      print('action ahahahaahahahahaha');
    });
    AwesomeNotifications().dismissedStream.listen((recievedNotification) {
      // ToDo handle dismissed notification
    });
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
              child: GestureDetector(
                onTapDown: _storeTapPosition,
                onTap: () {
                  viewModel.addOneDrink();
                  _checkCongratulations();
                },
                onDoubleTap: () {
                  viewModel.addDoubleDrink();
                  _checkCongratulations();
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
