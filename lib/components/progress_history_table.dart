import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/providers/drink_water_provider.dart';

class ProgressHistoryTable extends StatelessWidget {
  const ProgressHistoryTable({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DrinkWaterProvider>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('History'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Table(
                border: TableBorder.all(
                  color: Colors.black26,
                  width: 1,
                  style: BorderStyle.none,
                ),
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Center(
                          child: Text(
                            'Date',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Text(
                            'Amount',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Text(
                            'Progress',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...viewModel.progressHistory.items.map((item) {
                    return TableRow(
                      children: [
                        TableCell(
                          child: Text(
                            item.date,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Text(
                            item.amount,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Text(
                            item.progress,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
