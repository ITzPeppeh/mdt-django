import 'package:flutter/material.dart';
import 'package:mdt/models/constants.dart';
import 'package:mdt/models/profile.dart';
import 'package:mdt/models/sidebar.dart';
import 'package:mdt/models/database.dart';

class Profiles extends StatefulWidget {
  const Profiles({super.key});

  @override
  State<Profiles> createState() => _ProfilesState();
}

List _crimWidgetList = [];

class _ProfilesState extends State<Profiles> {

  refresh() async {
    setState(() {
      _crimWidgetList.clear();
    });
    if (ProfilesTexts.textProfileID == '') return;

    int id = int.parse(ProfilesTexts.textProfileID);

    for (var element in await MyDB().getReportsFromCivId(id)) {
      _crimWidgetList.add(TabProfile(
          title:
              "Appears in report ID: ${element.idReport}"));
    }
    setState(() {
      
    });
  }

  TextEditingController _stateIdTextFieldController = TextEditingController();
  TextEditingController _fullNameTextFieldController = TextEditingController();
  TextEditingController _imageURLTextFieldController = TextEditingController();
  TextEditingController _detailsTextFieldController = TextEditingController();

  @override
  void initState() {
    futureUsers = MyDB().getCivilians();

    super.initState();
  }

  late Future<List<Civilian>> futureUsers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          mySidebar(context, selectIdx: 1),
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
                        'Profiles',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
                FutureBuilder<List<Civilian>>(
                  future: futureUsers,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          List data = snapshot.data!;
                          return SearchProfile(
                            civID: data[index].id,
                            civName: data[index].fullName,
                            notifyParent: refresh,
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      Text("ERROR: ${snapshot.error}");
                    }
                    return const CircularProgressIndicator();
                  },
                )
              ]),
            ),
          ),
          Expanded(
            child: Container(
              width: 150,
              color: colorBox,
              margin: const EdgeInsets.all(6),
              child: Column(children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        ProfilesTexts.titleProfileName,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _crimWidgetList = [];
                          ProfilesTexts.clearAll();
                        });
                      },
                      icon: const Icon(Icons.create_new_folder),
                      color: textColor,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    IconButton(
                      onPressed: () async {
                          await MyDB().deleteUserFromId(int.parse(
                              _stateIdTextFieldController.text == ''
                                  ? '-1'
                                  : _stateIdTextFieldController.text));
                          futureUsers = MyDB().getCivilians();

                        setState(() {
                          _crimWidgetList = [];
                          ProfilesTexts.clearAll();
                        });
                      },
                      icon: const Icon(Icons.delete),
                      color: textColor,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    IconButton(
                      onPressed: () async {
                        if (_stateIdTextFieldController.text == '') return;
                          await MyDB().addOrUpdateUser(Civilian(
                              id: int.parse(
                                  _stateIdTextFieldController.text == ''
                                      ? '-1'
                                      : _stateIdTextFieldController.text),
                              fullName: _fullNameTextFieldController.text,
                              imageProfileURL:
                                  _imageURLTextFieldController.text,
                              detailsProfile:
                                  _detailsTextFieldController.text));
                          futureUsers = MyDB().getCivilians();

                        setState(() {
                          _crimWidgetList = [];
                          ProfilesTexts.clearAll();
                        });
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
                    Container(
                        width: 200,
                        height: 200,
                        margin: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image:
                              NetworkImage(ProfilesTexts.textProfileImageURL),
                          fit: BoxFit.cover,
                        ))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                  width: 200,
                                  child: TextField(
                                    style: const TextStyle(color: textColor),
                                    keyboardType: TextInputType.number,
                                    controller: _stateIdTextFieldController
                                      ..text = ProfilesTexts.textProfileID,
                                    decoration: const InputDecoration(
                                        labelStyle: TextStyle(color: textColor),
                                        labelText: 'State ID'),
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                  width: 200,
                                  child: TextField(
                                    style: const TextStyle(color: textColor),
                                    controller: _fullNameTextFieldController
                                      ..text = ProfilesTexts.textProfileName,
                                    decoration: const InputDecoration(
                                        labelStyle: TextStyle(color: textColor),
                                        labelText: 'Full Name'),
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                  width: 200,
                                  child: TextField(
                                    style: const TextStyle(color: textColor),
                                    controller: _imageURLTextFieldController
                                      ..text = ProfilesTexts.textProfileURL,
                                    decoration: const InputDecoration(
                                        labelStyle: TextStyle(color: textColor),
                                        labelText: 'Profile Image URL'),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _detailsTextFieldController
                        ..text = ProfilesTexts.detailsProfile,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: sideBarColor,
                          hintText: 'Document content goes here...',
                          hintStyle: TextStyle(color: secondaryTextColor)),
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
              width: 150,
              color: colorBox,
              margin: const EdgeInsets.all(6),
              child: Column(children: [
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Related Reports',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _crimWidgetList.length,
                  itemBuilder: (context, index) {
                    return _crimWidgetList[index];
                  },
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }
}
