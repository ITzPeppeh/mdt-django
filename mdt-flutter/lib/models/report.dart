import 'package:flutter/material.dart';
import 'package:mdt/models/constants.dart';
import 'package:mdt/models/database.dart';

class SearchReport extends StatefulWidget {
  final title;
  final repId;
  final dateCreate;
  final Function() notifyParent;

  const SearchReport({
    super.key,
    required this.title,
    required this.repId,
    required this.dateCreate,
    required this.notifyParent,
  });

  @override
  State<SearchReport> createState() => _SearchReportState();
}

class _SearchReportState extends State<SearchReport> {
  String dateToString = '';

  @override
  void initState() {
    dateToString =
        "${widget.dateCreate.day}-${widget.dateCreate.month}-${widget.dateCreate.year}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () async {
          Report report = await MyDB().getReportFromID(widget.repId);
          ReportsTexts.titleReportName =
              'Edit Incident (#${report.repId.toString()})';
          ReportsTexts.textReportTitle = report.reportName;
          ReportsTexts.textReportID = report.repId.toString();
          ReportsTexts.textDetails = report.detailsReport;
          widget.notifyParent();
        },
        child: Row(
          children: [
            Expanded(
                child: Container(
              height: 50,
              color: sideBarColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(widget.title,
                        style: const TextStyle(fontSize: 13)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                        "ID: ${widget.repId.toString()} - $dateToString",
                        style: const TextStyle(fontSize: 13)),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class ReportProfile extends StatefulWidget {
  final String stateID;
  final Function(bool, List) notifyParent;
  final bool isWarrant;

  const ReportProfile(
      {super.key, required this.notifyParent, required this.stateID, required this.isWarrant});

  @override
  State<ReportProfile> createState() => _ReportProfileState();
}

class _ReportProfileState extends State<ReportProfile> {
  bool? isWarrantA = false;

  TextEditingController _stateIDTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isWarrantA = widget.isWarrant;
    _stateIDTextFieldController.text = widget.stateID;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
          margin: const EdgeInsets.only(bottom: 5),
          height: 150,
          color: sideBarColor,
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                        width: 200,
                        child: TextField(
                          style: const TextStyle(color: textColor),
                          controller: _stateIDTextFieldController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelStyle: TextStyle(color: textColor),
                              labelText: 'State ID'),
                        )),
                  ),
                  const Expanded(child: SizedBox()),
                  IconButton(
                    onPressed: () {
                      widget.notifyParent(
                          true, [_stateIDTextFieldController.text, isWarrantA]);
                    },
                    icon: const Icon(Icons.delete),
                    color: textColor,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  IconButton(
                    onPressed: () {
                      widget.notifyParent(
                          false, [_stateIDTextFieldController.text, isWarrantA]);
                    },
                    icon: const Icon(Icons.save),
                    color: textColor,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  )
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: isWarrantA,
                    onChanged: (value) {
                      setState(() {
                        isWarrantA = value;
                      });
                    },
                  ),
                  const Text('Warrant for Arrest')
                ],
              )

              //
            ],
          ),
        ))
      ],
    );
  }
}
