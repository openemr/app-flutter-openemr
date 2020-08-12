import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/cupertino.dart';

class PatientListPage extends StatefulWidget {
  @override
  _PatientListPageState createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {

    @override
  void initState() {
    super.initState();
  }

  List list = [
    'Patient 1',
    'Patient 2',
    'Patient 3',
    'Patient 1',
    'Patient 2',
    'Patient 3',
    'Patient 1',
    'Patient 2',
    'Patient 3',
  ];
  bool fav = false;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: GFAppBar(
          backgroundColor: GFColors.DARK,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                child: Icon(
                  CupertinoIcons.back,
                  color: GFColors.SUCCESS,
                ),
              )),
          title: const Text(
            'Patient List',
            style: TextStyle(fontSize: 17),
          ),
          centerTitle: true,
        ),
        body: ListView(
          physics: const ScrollPhysics(),
          children: <Widget>[
            GFSearchBar(
                searchList: list,
                searchQueryBuilder: (query, list) => list
                    .where((item) =>
                        item.toLowerCase().contains(query.toLowerCase()))
                    .toList(),
                overlaySearchListItemBuilder: (item) => Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item,
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                onItemSelected: (item) {
                  setState(() {
                    print('$item');
                  });
                }),
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 30, bottom: 10),
              child: GFTypography(
                text: 'Starred Patient',
                type: GFTypographyType.typo5,
                dividerWidth: 25,
                dividerColor: Color(0xFF19CA4B),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 30, bottom: 10),
              child: GFTypography(
                text: 'History',
                type: GFTypographyType.typo5,
                dividerWidth: 25,
                dividerColor: Color(0xFF19CA4B),
              ),
            ),
          ],
        ),
      );
}
