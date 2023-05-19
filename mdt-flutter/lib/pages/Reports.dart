import 'package:flutter/material.dart';
import 'package:mdt/models/constants.dart';
import 'package:mdt/models/report.dart';
import 'package:mdt/models/sidebar.dart';
import 'package:mdt/models/database.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  late List _crimWidgetList = [];

  refresh() async {
      _crimWidgetList = [];
      if (ReportsTexts.textReportID == '') return;

      int id = int.parse(ReportsTexts.textReportID);

      for (var element in await MyDB().getCrimsFromRepId(id)) {
        _crimWidgetList.add(ReportProfile(
            notifyParent: addToReport,
            stateID: element.idCiv.toString(),
            isWarrant : element.isWarrant));
      }
    
    setState(() {});
  }

  addToReport(bool deleteReport, List lol) { //FROM HERE
    if (!deleteReport) {
      if (ReportsTexts.textReportID == '') return;
      if (lol[0] == '') return;
      print(lol[1]);
      MyDatabase.listCrimReports.add(Arrested(
          idReport: int.parse(ReportsTexts.textReportID),
          idCiv: int.parse(lol[0]),
          isWarrant: lol[1]));
      
      MyDatabase.listUsers.forEach((element) {
        print('---');
        print(element.id);
        print(lol[1]);
        print('--');
         if(element.id == int.parse(lol[0]) && element.isWarant != lol[1]) {
          print('dentro');
        element.isWarant = lol[1];}});
      setState(() {
        ReportsTexts.clearAll();
        /*TODO: DELETE ONLY HIS WIDGET(?)*/
        _crimWidgetList.clear();
      });
    } else {
      if (ReportsTexts.textReportID == '') return;

      MyDatabase.listCrimReports.removeWhere((element) =>
          element.idReport.toString() == ReportsTexts.textReportID);

      setState(() {
        ReportsTexts.clearAll();
        _crimWidgetList.clear();
      });
    }
  }

  TextEditingController _titleReportTextFieldController =
      TextEditingController();
  TextEditingController _detailsReportTextFieldController =
      TextEditingController();

  @override
  void initState() {
    futureReports = MyDB().getReports();
    
    super.initState();
  }
  
  late Future<List<Report>> futureReports;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        mySidebar(context, selectIdx: 2),
        Expanded(
          child: Container(
            color: colorBox,
            margin: const EdgeInsets.all(6),
            child: Column(children: [
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Reports',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),/*
              TextField(
                style: const TextStyle(color: textColor),
                decoration: const InputDecoration(
                    labelStyle: TextStyle(color: textColor),
                    labelText: 'Search',
                    suffixIcon: Icon(Icons.search)),
                onChanged: (textValue) {
                  List results = [];
                  if (textValue.isEmpty) {
                    results = MyDatabase.listReports;
                  } else {
                    results = MyDatabase.listReports
                        .where((element) => element.reportName
                            .toLowerCase()
                            .contains(textValue.toLowerCase()))
                        .toList();
                  }

                  setState(() {
                    _foundReports = results;
                  });
                },
              ),*/
              FutureBuilder<List<Report>>(
                future: futureReports,
                builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          List data = snapshot.data!;
                          return SearchReport(
                            title: data[index].reportName,
                            repId: data[index].repId,
                            dateCreate: data[index].dateCreated,
                            notifyParent: refresh,
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      Text("ERROR: ${snapshot.error}");
                    }
                    return const CircularProgressIndicator();
                  }
              )
            ]),
          ),
        ),
        Expanded(
          child: Container(
            color: colorBox,
            margin: const EdgeInsets.all(6),
            child: Column(children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      ReportsTexts.titleReportName,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        ReportsTexts.clearAll();
                        _crimWidgetList.clear();
                      });
                    },
                    icon: const Icon(Icons.create_new_folder),
                    color: textColor,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        MyDB().deleteReportFromId(int.parse(
                            ReportsTexts.textReportID == ''
                                ? '-1'
                                : ReportsTexts.textReportID));
                        futureReports = MyDB().getReports();
                        ReportsTexts.clearAll();
                      });
                    },
                    icon: const Icon(Icons.delete),
                    color: textColor,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  IconButton(
                    onPressed: () {
                      if (ReportsTexts.textReportTitle == '') return;
                      setState(() {
                        MyDB().addOrUpdateReport(Report(
                            repId: int.parse(ReportsTexts.textReportID == ''
                                ? '-1'
                                : ReportsTexts.textReportID),
                            reportName: ReportsTexts.textReportTitle,
                            dateCreated: DateTime.now(),
                            detailsReport: ReportsTexts.textDetails));
                        
                        futureReports = MyDB().getReports();
                        ReportsTexts.clearAll();
                      });
                    },
                    icon: const Icon(Icons.save),
                    color: textColor,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  )
                ],
              ),
              TextField(
                onChanged: (value) {
                  ReportsTexts.textReportTitle = value;
                },
                controller: _titleReportTextFieldController
                  ..text = ReportsTexts.textReportTitle,
                style: const TextStyle(color: textColor),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: textColor),
                  prefixIcon: Icon(
                    Icons.carpenter,
                    color: textColor,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      ReportsTexts.textDetails = value;
                    },
                    controller: _detailsReportTextFieldController
                      ..text = ReportsTexts.textDetails,
                    decoration: const InputDecoration(
                        filled: true, fillColor: sideBarColor),
                    style: const TextStyle(color: textColor),
                    keyboardType: TextInputType.multiline,
                    minLines: 25,
                    maxLines: null,
                  ),
                ),
              )
            ]),
          ),
        ),
        Expanded(
          child: Container(
            color: colorBox,
            margin: const EdgeInsets.all(6),
            child: Column(children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Add Criminal Scum',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _crimWidgetList.add(ReportProfile(
                            notifyParent: addToReport, stateID: '', isWarrant: false,));
                      });
                    },
                    icon: const Icon(Icons.add),
                    color: textColor,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  )
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _crimWidgetList.length,
                itemBuilder: (context, index) {
                  return _crimWidgetList[
                      index];
                },
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
